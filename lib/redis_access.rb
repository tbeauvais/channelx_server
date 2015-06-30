require 'json'

module RedisAccess

  attr_accessor :client

  def initialize(client)
    @client = client
  end

  def fetch_all
    items = client.hgetall hash_key
    items.keys.map {|key| JSON.parse(items[key])}
  end

  def fetch(id)
    data = client.hget hash_key, id
    data ? JSON.parse(data) : nil
  end

  def add(data)
    data['id'] = SecureRandom.uuid
    client.hset hash_key, data['id'], data.to_json
    data
  end

  def update(id, data)
    client.hset hash_key, id, data.to_json
    data
  end

  def delete(id)
    client.hdel hash_key, id
  end

  def hash_key
    raise 'You must implement hash_key method'
  end

end