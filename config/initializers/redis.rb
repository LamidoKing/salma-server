require 'redis'

redis = Redis.new (
    :host = ENV['REDIS_URL'],
    :port = ENV['REDIS_PORT'],
    :password = ENV['REDIS_PASSWORD']
    )


