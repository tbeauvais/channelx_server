class App < Sinatra::Base

  namespace '/api/v1' do

    get '/businesses' do
      json business_access.fetch_all
    end

    get '/businesses/:id' do
      json business_access.fetch params[:id]
    end

    post '/businesses' do
      content_type :json
      status 201
      message = JSON.parse(request.body.read)
      business_access.add(message)
      {id: message['id']}.to_json
    end

    delete '/businesses/:id' do
      content_type :json
      status 204
      business_access.delete(params[:id])
      body ''
    end

  end

  private

  def business_access
    @business_access ||= BusinessAccess.new(redis_client)
  end

end
