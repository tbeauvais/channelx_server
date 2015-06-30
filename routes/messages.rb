class App < Sinatra::Base

  namespace '/api/v1' do

    get '/messages' do
      json message_access.fetch_all
    end

    get '/messages/:id' do
      json message_access.fetch params[:id]
    end

  end

  private

  def message_access
    @message_access ||= MessageAccess.new(redis_client)
  end

end
