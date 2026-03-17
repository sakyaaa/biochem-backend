# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'
require_relative '../lib/jwt_cookie_railtie'

Bundler.require(*Rails.groups)

module BiochemBackend
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = true
    config.time_zone = 'Moscow'
    config.i18n.default_locale = :en
    config.i18n.available_locales = %i[en ru]

    config.secret_key_base = ENV.fetch('SECRET_KEY_BASE', nil)

    # Нужен для httpOnly cookie с JWT
    config.middleware.use ActionDispatch::Cookies
  end
end
