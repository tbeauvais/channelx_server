require 'redis_access'

class MessageAccess

  include RedisAccess

  HASH_KEY = 'message_data'

  def hash_key
    HASH_KEY
  end

end