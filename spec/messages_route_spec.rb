require 'spec_helper'

describe 'App' do

  context 'messages' do

    context 'get' do

      let(:message) { {'name' => 'test', 'link' => 'www.test.com'} }
      subject(:message_access) { MessageAccess.new(RedisConnection.client) }

      it 'status is ok' do
        get '/api/v1/messages'
        expect(last_response).to be_ok
      end

      it 'responds with all messages' do
        message_access.add(message)
        get '/api/v1/messages'
        messages = JSON.parse(last_response.body)
        expect(messages).to eq [message]
      end

      it 'responds with specific message' do
        message_access.add(message)
        get "/api/v1/messages/#{message['id']}"
        message = JSON.parse(last_response.body)
        expect(message).to eq message
      end

    end

  end

end
