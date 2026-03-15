require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module BiochemBackend
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = true
    config.time_zone = "Moscow"
    config.i18n.default_locale = :ru

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
  end
end
