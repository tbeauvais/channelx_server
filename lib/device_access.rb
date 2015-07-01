require 'redis_access'

class DeviceAccess

  include RedisAccess

  HASH_KEY = 'device_data'

  def hash_key
    HASH_KEY
  end

end
