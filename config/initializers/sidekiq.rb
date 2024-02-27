Sidekiq.configure_server do |config|
  # config.redis = { url: 'redis://localhost:6379/0' }
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
  config.logger = Sidekiq::Logger.new($stdout)
end

Sidekiq.configure_client do |config|
  # config.redis = { url: 'redis://localhost:6379/0' }
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end