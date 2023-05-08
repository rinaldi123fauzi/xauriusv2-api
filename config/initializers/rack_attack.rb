Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

Rack::Attack.throttle('requests by ip', limit: ENV['RACK_ATTACK_REQUEST_LIMIT'].to_i, period: ENV['RACK_ATTACK_REQUEST_PERIOD'].to_i) do |req|
  req.ip
end