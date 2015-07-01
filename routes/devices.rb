class App < Sinatra::Base

  namespace '/api/v1' do

    get '/devices' do
      json device_access.fetch_all
    end

    get '/devices/:id' do
      json device_access.fetch params[:id]
    end

    post '/devices' do
      content_type :json
      status 201
      message = JSON.parse(request.body.read)
      device_access.add(message)
      {id: message['id']}.to_json
    end

    delete '/devices/:id' do
      content_type :json
      status 204
      device_access.delete(params[:id])
      body ''
    end

  end

  private

  def device_access
    @device_access ||= DeviceAccess.new(redis_client)
  end

end
