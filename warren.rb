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
    @labels = $neo.list_labels
    respond_with :index
  end

  # Labels
  #
  # Responds to html and json requests
  get '/labels/:label', :provides => [:html, :json] do
    @nodes = $neo.get_nodes_labeled(params[:label])
    respond_with params[:label].downcase.to_sym
  end
end
