require 'spec_helper'

describe MessageAccess do

  subject(:message_access) { MessageAccess.new(RedisConnection.client) }
  let(:message) { {'name' => 'test', 'link' => 'www.test.com'} }

  context '#fetch_all' do

    it 'returns empty array when no messages' do
      expect(message_access.fetch_all).to eq []
    end

    it 'returns messages added' do
      message_access.add({})
      expect(message_access.fetch_all.size).to eq 1
    end

  end

  context '#add' do

    it 'adds messages' do
      message_access.add(message)
      expect(message_access.fetch(message['id'])).to eq message
    end

    it 'sets uuid' do
      message_access.add(message)
      expect(message['id']).to eq DEFAULT_UUID
    end

  end

end
