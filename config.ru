# Global var for environment testing
$rack_env = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'

# Only include the debugger in local envs
require 'debugger' if %w(development test).include?($rack_env)

# Try to setup some logging...
root = ::File.dirname(__FILE__)
logfile = ::File.join(root, 'log', "#{$rack_env}.log")

require 'logger'
class ::Logger; alias_method :write, :<<; end
logger = ::Logger.new(logfile)

use Rack::CommonLogger, logger

require './warren'
run Warren

