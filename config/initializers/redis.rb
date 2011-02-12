require 'redis'

RedisConfig = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env].symbolize_keys

REDIS = Redis.new(:host => RedisConfig[:host], :port => RedisConfig[:port])
