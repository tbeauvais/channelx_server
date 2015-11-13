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

    # Param
    # :id - id of business
    # :notify - if true, send notification to user
    # :type - 'Flowers' or 'Petstore'
    post '/messages/:id/subscribe' do
      content_type :json
      status 201
      message = JSON.parse(request.body.read)

      if message['type']
        if message['type'] == 'Flowers'
          flower = 'https://innojam-channel-x.s3.amazonaws.com/221e6bd0-6b99-0133-47d5-46a2714e2106.html'
          message.store('link', flower)
        elsif message['type'] == 'Petstore'
          petstore = 'https://innojam-channel-x.s3.amazonaws.com/0e1fdaa0-6b9a-0133-47d5-46a2714e2106.html'
          message.store('link', petstore)
        end
      end

      message_access.add(message)

      device_access.fetch_all.each do |device|
        puts "Sending notification to #{device['token']} #{message['lastText']}"
        Notifier.send_notification(device['token'], message['lastText'])
      end

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
