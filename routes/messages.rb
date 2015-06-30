class App < Sinatra::Base

  namespace '/api/v1' do

    get '/messages' do
      json message_access.fetch_all
    end

    get '/messages/:id' do
      json message_access.fetch params[:id]
    end

    post '/messages' do
      content_type :json
      status 201
      message = JSON.parse(request.body.read)
      message_access.add(message)
      {id: message['id']}.to_json
    end

    delete '/messages/:id' do
      content_type :json
      status 204
      message_access.delete(params[:id])
      body ''
    end

  end

  private

  def message_access
    @message_access ||= MessageAccess.new(redis_client)
  end

end
