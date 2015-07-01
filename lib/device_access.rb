require 'redis_access'

class DeviceAccess

  include RedisAccess

  HASH_KEY = 'device_data'

  def add(data)
    data['id'] = data['token']
    client.hset hash_key, data['id'], data.to_json
    data
  end

  def hash_key
    HASH_KEY
  end

end
