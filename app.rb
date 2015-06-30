require './load_path'
require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/cross_origin'
require 'message_access'
require 'redis_connection'

require 'sinatra/reloader' if ENV['RACK_ENV'] == 'development'
require 'pry' if %w[development test].include? ENV['RACK_ENV']

class App < Sinatra::Base

  helpers Sinatra::JSON
  register Sinatra::Namespace
  register Sinatra::CrossOrigin
  configure :development do
    register Sinatra::Reloader
  end

  def redis_client
    RedisConnection.client
  end

  options '*' do
    response.headers['Access-Control-Allow-Methods'] = 'HEAD,GET,PUT,POST,DELETE,OPTIONS'
    response.headers['Allow'] = 'HEAD,GET,PUT,POST,DELETE,OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
    200
  end

  # Load API routes
  require 'messages'
  require 'emails'

end
