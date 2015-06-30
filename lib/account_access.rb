require 'redis_access'

class AccountAccess

  include RedisAccess

  HASH_KEY = 'account_data'

  def hash_key
    HASH_KEY
  end

end
