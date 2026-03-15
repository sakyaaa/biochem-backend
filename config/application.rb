require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module BiochemBackend
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = true
    config.time_zone = "Moscow"
    config.i18n.default_locale = :ru

    config.secret_key_base = ENV["SECRET_KEY_BASE"]
  end
end
