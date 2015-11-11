require 'redis_access'

class BusinessAccess

  include RedisAccess

  HASH_KEY = 'business_data'

  def fetch_all
    items = client.hgetall hash_key
    data = items.keys.map {|key| JSON.parse(items[key])}
    # TODO need to use a sorted data store
    data.sort_by { |k| k['time'] || 0 }.reverse!
  end

  def add(data)
    data['id'] = SecureRandom.uuid
    data['time'] = Time.now.to_i
    client.hset hash_key, data['id'], data.to_json
    data
  end

  def hash_key
    HASH_KEY
  end

end
