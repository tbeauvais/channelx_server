require 'sinatra'
require 'sinatra/contrib'

require 'sinatra/reloader' if ENV['RACK_ENV'] == 'development'
require 'pry' if %w[development test].include? ENV['RACK_ENV']

class App < Sinatra::Base

  helpers Sinatra::JSON
  register Sinatra::Namespace
  configure :development do
    register Sinatra::Reloader
  end

  namespace '/api/v1' do

    get '/hello' do
      json message: 'Hello There!!!'
    end

  end

  require_relative 'routes/messages'

end




