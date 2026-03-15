require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module BiochemBackend
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = true
    config.time_zone = "Moscow"
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en, :ru]

    config.secret_key_base = ENV["SECRET_KEY_BASE"]

    # Нужен для httpOnly cookie с JWT
    config.middleware.use ActionDispatch::Cookies
  end
end
