require 'bundler'
Bundler.require

require 'sinatra/base'
require 'sinatra/respond_with'

# Global var for environment testing
$rack_env ||= ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'

# Configure ruby client for Neo4j
# TODO: move to config dir
Neography.configure do |config|
  config.protocol       = "http://"
  config.server         = "localhost"
  config.port           = 7474
  config.directory      = ""  # prefix this path with '/' 
  config.cypher_path    = "/cypher"
  config.gremlin_path   = "/ext/GremlinPlugin/graphdb/execute_script"
  config.log_file       = "neography.log"
  config.log_enabled    = false
  config.max_threads    = 20
  config.authentication = nil  # 'basic' or 'digest'
  config.username       = nil
  config.password       = nil
  config.parser         = MultiJsonParser
end

@neo = Neography::Rest.new

class Warren < Sinatra::Base
  register Sinatra::RespondWith

  # Index
  #
  # Responds to html and json requests
  get '/', :provides => [:html, :json] do
  end
end
