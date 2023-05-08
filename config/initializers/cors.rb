Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins ENV['WWW_DOMAIN']
    origins '*'
    resource '*', headers: :any, methods: [:get, :post]
  end
end