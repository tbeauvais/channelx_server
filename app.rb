require './load_path'
require 'sinatra'
require 'sinatra/contrib'
require 'message_access'
require 'redis_connection'

require 'sinatra/reloader' if ENV['RACK_ENV'] == 'development'
require 'pry' if %w[development test].include? ENV['RACK_ENV']

class App < Sinatra::Base

  helpers Sinatra::JSON
  register Sinatra::Namespace
  configure :development do
    register Sinatra::Reloader
  end

  def redis_client
    RedisConnection.client
  end

  # Load API routes
  require 'messages'
  require 'emails'

end
