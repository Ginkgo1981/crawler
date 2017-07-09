# require "redis"

# rx = /port.(\d+)/
# redis_conf = File.read(Rails.root.join("config/redis", "#{Rails.env}.conf"))
# port = rx.match(redis_conf)[1]
# res = `ps aux | grep redis-server | grep -v grep`
# unless res.include?("redis-server")
#   `redis-server #{Rails.root.join("config/redis", "#{Rails.env}.conf")}`
#   res = `ps aux | grep redis-server | grep -v grep`
#   raise "Couldn't start redis" unless res.include?("redis-server") && res.include?(":#{port}")
# end


class Redis

  def cache(key, value, expire=nil)
    if get(key).nil?
      set(key, value)
      expire(key, expire) if expire
      value
    else
      get(key)
    end
  end

end

conf_file = File.join('config', 'redis.yml')
redis = if File.exists?(conf_file)
           conf = YAML.load(File.read(conf_file))
           conf[Rails.env.to_s].blank? ? Redis.new : Redis.new(conf[Rails.env.to_s])
         else
           Redis.new
        end
$redis = Redis::Namespace.new(:crawler, :redis => redis)



# To clear out the db before each test
$redis.flushdb if Rails.env == "test"

rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

# Resque.redis = YAML.load_file(rails_root + '/config/redis.yml')[rails_env]