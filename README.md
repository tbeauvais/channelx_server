Channel-X
====================

## Run the server

    brew update
    brew install redis
    redis-server /usr/local/etc/redis.conf
    bundle install
    rackup
    
# To test it

    http://localhost:9292/api/v1/messages
