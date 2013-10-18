require 'rubygems'
require 'nokogiri'

class UnImporter

  def self.run
    @doc = Nokogiri::XML( open(File.join(RAILS_ROOT, "db/data/consolidatedlist.xml")))

    @network = Network.find_or_create_by_name "AfPak"

    @individuals = @doc.search("//CONSOLIDATED_LIST/INDIVIDUALS/INDIVIDUAL")
    puts "Found #{@individuals.size} individuals."

    @people = @places = @groups = []
    @individuals.each do |individual|
      begin
        first_name = (first_name_node = individual.at("FIRST_NAME")) ? first_name_node.text.strip.titleize : ''
        last_name = (last_name_node = individual.at("SECOND_NAME")) ? last_name_node.text.strip.titleize : ''

        raise "We need at least a first name or a last name" if first_name.blank? && last_name.blank?

        puts "Parsing data for #{first_name} #{last_name}"
        group_name = individual.at("UN_LIST_TYPE").text.strip.titleize
        description = (description_node = individual.at("COMMENTS1")) ? description_node.text.strip : ''
        nationalities = (nationality_nodes = individual.search("NATIONALITY/VALUE")) ? nationality_nodes.map(&:text).join("/") : ''
        dob = (dob_node = individual.at("INDIVIDUAL_DATE_OF_BIRTH/DATE")) ? dob_node.text : ''
        pob = if place_of_birth_nodes = individual.at("INDIVIDUAL_PLACE_OF_BIRTH")
                city = (city_node = place_of_birth_nodes.at("CITY")) ? city_node.text : ''
                country = (country_node = place_of_birth_nodes.at("COUNTRY")) ? country_node.text : ''
                [city, country].compact.join(', ')
              else
                ''
              end

        places << pob

        aliases = individual.search('INDIVIDUAL_ALIAS/ALIAS_NAME').map{|aka| aka.text.strip }
        person = { :first_name => first_name, :last_name => :last_name, :bio => description, :dob => dob, :nationalities => nationalities, :pob => pob, :group => group_name, :aka => aliases }

        people << person

      rescue Exception => e
        puts "Error while parsing individual: #{e.message}"
        require 'ruby-debug'; Debugger.start; Debugger.settings[:autoeval] = 1; Debugger.settings[:autolist] = 1; debugger
        puts e.backtrace
        puts "XML:"
        puts individual
      end
    end
    @entities = @doc.search("//CONSOLIDATED_LIST/ENTITIES/ENTITY")

    puts "Found #{@entities.size} entities/groups."
    @entities.each do |entity|
      begin
        parent_group_name = entity.at('UN_LIST_TYPE').text.strip # this is al qaida so far for every entity
        name = entity.at('FIRST_NAME').text.strip
        aliases = entity.search('ENTITY_ALIAS/ALIAS_NAME').map{|aka| aka.text.strip }

        group = { :name => name, :parent_group_name => parent_group_name, :aka => aliases }
        groups << group

      rescue Exception => e
        puts "Error while parsing group: #{e.message}"
        puts e.backtrace
        puts "XML:"
        puts entity
      end
    end

    puts "People:"
    puts people.inspect
    puts "Places:"
    puts places.inspect
    puts "Groups:"
    puts groups.inspect
  end
end

UnImporter.run
