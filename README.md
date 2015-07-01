Channel-X
====================

## Run the server

    brew update
    brew install redis
    redis-server /usr/local/etc/redis.conf
    bundle install
    export AWS_ACCESS_KEY_ID=AKIAJ6AJ73YU3A5PGM4Q
    export AWS_SECRET_ACCESS_KEY=(ask rich)
    rspec spec
    rackup
    http://localhost:9292/api/v1/messages

# Alternative startup

    bundle exec puma -p 8080
    http://localhost:8080/api/v1/messages
