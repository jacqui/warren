#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'neography'

initializers = Dir.glob(File.expand_path('../config/initializers/*.rb', File.dirname(__FILE__))).sort
initializers.each { |file| require file }

class UnImporter

  def self.run
    @doc = Nokogiri::XML( open("http://www.un.org/sc/committees/1267/AQList.xml") )

    @individuals = @doc.search("//CONSOLIDATED_LIST/INDIVIDUALS/INDIVIDUAL")
    puts "Found #{@individuals.size} individuals."

    @people = []
    @places = []
    @groups = []
    @countries = []
    @cities = []

    @individuals.each do |individual|
      begin
        first_name = (first_name_node = individual.at("FIRST_NAME")) ? first_name_node.text.strip : ''
        last_name = (last_name_node = individual.at("SECOND_NAME")) ? last_name_node.text.strip : ''

        raise "We need at least a first name or a last name" if first_name.nil? && last_name.nil?

        group_name = individual.at("UN_LIST_TYPE").text.strip
        description = (description_node = individual.at("COMMENTS1")) ? description_node.text.strip : ''
        nationalities = (nationality_nodes = individual.search("NATIONALITY/VALUE")) ? nationality_nodes.map(&:text).join("/") : ''
        dob = (dob_node = individual.at("INDIVIDUAL_DATE_OF_BIRTH/DATE")) ? dob_node.text.gsub("T00:00:00", "") : ''
        pob = if place_of_birth_nodes = individual.at("INDIVIDUAL_PLACE_OF_BIRTH")
                city = (city_node = place_of_birth_nodes.at("CITY")) ? city_node.text : nil
                country = (country_node = place_of_birth_nodes.at("COUNTRY")) ? country_node.text : nil
                if country
                  country_data = { :name => country, :id => country.gsub(/\s/, '_').gsub(/[^A-Za-z]/, '').downcase }
                  @countries << country_data
                  if city
                    @cities << { :name => city, :country => country, :id => city.gsub(/\s/, '_').gsub(/[^A-Za-z]/, '').downcase, :country_id => country_data[:id]} 
                  end
                elsif city
                  @cities << { :name => city, :id => city.gsub(/\s/, '_').gsub(/[^A-Za-z]/, '').downcase }
                end
                [city, country].compact.join(', ')
              else
                ''
              end

        @places << pob

        aliases = individual.search('INDIVIDUAL_ALIAS/ALIAS_NAME').map{|aka| aka.text.strip.gsub(/"'/, '') }
        person = { :first_name => first_name, :last_name => last_name, :bio => description.gsub('"', '\"'), :dob => dob, :nationalities => nationalities, :pob => pob, :group => group_name }
        person[:aka] = aliases if aliases && aliases.size > 0

        @people << person

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
        aliases = entity.search('ENTITY_ALIAS/ALIAS_NAME').map{|aka| aka.text.strip.gsub(/"'/, '') }

        group = { :name => name, :parent_group_name => parent_group_name }
        group[:aka] = aliases if aliases && aliases.size > 0
        @groups << group

      rescue Exception => e
        puts "Error while parsing group: #{e.message}"
        puts e.backtrace
        puts "XML:"
        puts entity
      end
    end

    puts "Found #{@countries.size} countries"
    puts "Found #{@groups.size} groups"
    puts "Found #{@people.size} people"

    cyphers = []
    @groups.each do |group|
      cyphers << " (:Group { name : \"#{group[:name]}\", parent_group_name: \"#{group[:parent_group_name]}\", aka : \"#{group[:aka] ? group[:aka].join(', ') : ''}\"}), "
    end

    @countries.compact!
    @countries.uniq!
    @countries.each do |data|
      cyphers << " (#{data[:id]}:Country { name : \"#{data[:name]}\" }), "
    end

    @cities.compact!
    @cities.uniq!
    @cities.each do |data|
      if data[:name] && data[:country]
        cyphers << " (#{data[:id]}:City { name : \"#{data[:name]}\" }), "
        cyphers << " (#{data[:id]})-[:LOCATED_IN]->(#{data[:country_id]}), "
      elsif data[:name]
        cyphers << " (#{data[:id]}:City { name : \"#{data[:name]}\" }), "
      end
    end

    cyphers << ""
    cyphers << ""

    @people.each do |person|
      aliases = person[:aka] ? person[:aka].join(', ') : ''
      cyphers << "(:Person { first_name: \"#{person[:first_name]}\", last_name: \"#{person[:last_name]}\", bio: \"#{person[:bio]}\", dob: \"#{person[:dob]}\", nationalities: \"#{person[:nationalities]}\", pob: \"#{person[:pob]}\", group: \"#{person[:group]}\", aka: \"#{aliases}\" }), "
    end
    require 'pp'
    puts cyphers
  end
end

UnImporter.run
