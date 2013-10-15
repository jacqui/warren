Dir['tasks/*.rake'].sort.each { |ext| load ext }

require 'sinatra/asset_pipeline/task.rb'
require './assembly'
Sinatra::AssetPipeline::Task.define! Assembly

# Our infrastructure/chef deploy expects assets:precompile:primary to exist
# alias it here!
task 'assets:precompile:primary' => 'assets:precompile'

