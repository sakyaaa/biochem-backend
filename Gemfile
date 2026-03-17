# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.7'

gem 'bootsnap', require: false
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'rails', '~> 8.0.2'

gem 'devise', '~> 4.9'
gem 'devise-jwt', '~> 0.11'
gem 'jsonapi-serializer', '~> 2.2'
gem 'kaminari', '~> 1.2'
gem 'pg_search', '~> 2.3'
gem 'pundit', '~> 2.4'
gem 'rack-cors', '~> 2.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'dotenv-rails'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.4'
  gem 'rspec-rails', '~> 7.1'
end

group :development do
  gem 'rubocop-rails-omakase', require: false
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.2'
  gem 'shoulda-matchers', '~> 6.4'
end
