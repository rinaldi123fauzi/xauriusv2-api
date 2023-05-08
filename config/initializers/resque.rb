require 'resque'
require 'resque/server'

# Set Redis connection configuration for Resque
Resque.redis = {
  url: ENV['REDIS_URL'],
  password: ENV['REDIS_PASSWORD']
}

# Set Resque server authentication
if ENV['REDIS_PASSWORD'].present?
  Resque::Server.use(Rack::Auth::Basic) do |user, password|
    password == ENV['REDIS_PASSWORD']
  end
end