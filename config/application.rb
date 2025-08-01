require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SegDevChallenge
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Exibir variáveis de ambiente configuradas
        %w[
          SPLUNK_HOST
          SPLUNK_PORT
          SPLUNK_TOKEN
          SPLUNK_INDEX
          SPLUNK_SOURCE
          SPLUNK_SOURCETYPE
          SPLUNK_SSL
          RAILS_ENV
          DATABASE_URL
          SECRET_KEY_BASE
          RACK_ENV
          PORT
        ].each { |var| puts "#{var}: #{ENV[var]}" }

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    require_relative '../app/middleware/jwt_auth_middleware'
    require_relative '../app/middleware/metrics_middleware'
    config.autoload_paths << Rails.root.join('app', 'middleware')

    # Adicionar middlewares na ordem correta
    config.middleware.use MetricsMiddleware
    config.middleware.use JwtAuthMiddleware

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
