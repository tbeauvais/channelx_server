require 'json'

module RedisAccess

  attr_accessor :client

  def initialize(client)
    @client = client
  end

  def fetch_all
    messages = client.hgetall hash_key
    messages.keys.map {|key| JSON.parse(messages[key])}
  end

  def fetch(id)
    message = client.hget hash_key, id
    message ? JSON.parse(message) : nil
  end

  def add(message)
    message['id'] = SecureRandom.uuid
    client.hset hash_key, message['id'], message.to_json
    message
  end

  def update(id, message)
    client.hset hash_key, id, message.to_json
    model
  end

  def delete(id)
    client.hdel hash_key, id
  rescue
    false
    true
  end

  def hash_key
    raise 'You must implement hash_key method'
  end

end