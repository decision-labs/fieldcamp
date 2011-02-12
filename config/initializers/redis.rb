require 'redis'

Redis_config = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env].symbolize_keys

redis = Redis.new(:host => Redis_config[:host], :port => Redis_config[:port])
