require 'bundler'
Bundler.require

require 'sinatra/base'
require 'sinatra/respond_with'

# Global var for environment testing
$rack_env ||= ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'

initializers = Dir.glob(File.expand_path('config/initializers/*.rb', File.dirname(__FILE__))).sort
initializers.each { |file| require file }

class Warren < Sinatra::Base
  register Sinatra::RespondWith

  # Index
  #
  # Responds to html and json requests
  get '/', :provides => [:html, :json] do
    @labels = $neo.list_labels.sort
    @relationship_types = $neo.list_relationship_types
    respond_with :index
  end

  # Labels
  #
  # Responds to html and json requests
  get '/labels/:label', :provides => [:html, :json] do
    @nodes = $neo.get_nodes_labeled(params[:label])
    respond_with params[:label].downcase.to_sym
  end

  # Node
  #
  # Responds to html and json requests
  get '/nodes/:id', :provides => [:html, :json] do
    @node = $neo.get_node(params[:id])
    respond_with :node
  end

  # Nodes (generic listing)
  #
  # Responds to html and json requests
  get '/nodes', :provides => [:html, :json] do
    @labeled_nodes = $neo.list_labels.sort.map {|label| [label, $neo.get_nodes($neo.get_nodes_labeled(label))] }
    respond_with :nodes
  end
end
