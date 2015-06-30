require 'spec_helper'

describe 'App' do

  context 'messages' do

    subject(:message_access) { MessageAccess.new(RedisConnection.client) }
    let(:message) { {'name' => 'test', 'link' => 'www.test.com'} }

    context 'get' do

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

    context 'post' do

      it 'responds with status is created' do
        post '/api/v1/messages', message.to_json
        expect(last_response.status).to eq 201
      end

      it 'replies with new message id' do
        post '/api/v1/messages', message.to_json
        expect(JSON.parse(last_response.body)).to eq({'id' => DEFAULT_UUID})
      end

      it 'add new message' do
        expect{post '/api/v1/messages', message.to_json}.to change{message_access.fetch_all.size}.from(0).to(1)
      end

    end

    context 'delete' do

      it 'responds with status deleted' do
        delete "/api/v1/messages/#{DEFAULT_UUID}"
        expect(last_response.status).to eq 204
      end

      it 'removes specified message' do
        message_access.add(message)
        expect{delete "/api/v1/messages/#{DEFAULT_UUID}"}.to change{message_access.fetch_all.size}.from(1).to(0)
      end

    end

  end

end
