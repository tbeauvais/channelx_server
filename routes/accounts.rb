class App < Sinatra::Base

  namespace '/api/v1' do

    get '/accounts' do
      json account_access.fetch_all
    end

    get '/accounts/:id' do
      json account_access.fetch params[:id]
    end

    post '/accounts' do
      content_type :json
      status 201
      message = JSON.parse(request.body.read)
      account_access.add(message)
      {id: message['id']}.to_json
    end

    delete '/accounts/:id' do
      content_type :json
      status 204
      account_access.delete(params[:id])
      body ''
    end

  end

  private

  def account_access
    @account_access ||= AccountAccess.new(redis_client)
  end

end
