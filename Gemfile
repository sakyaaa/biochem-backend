source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.7"

gem "rails", "~> 8.0.2"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"
gem "bootsnap", require: false

gem "devise", "~> 4.9"
gem "devise-jwt", "~> 0.11"
gem "pundit", "~> 2.4"
gem "jsonapi-serializer", "~> 2.2"
gem "kaminari", "~> 1.2"
gem "pg_search", "~> 2.3"
gem "rack-cors", "~> 2.0"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "rspec-rails", "~> 7.1"
  gem "factory_bot_rails", "~> 6.4"
  gem "faker", "~> 3.4"
  gem "dotenv-rails"
  gem "debug", platforms: %i[mri windows]
end

group :development do
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "shoulda-matchers", "~> 6.4"
  gem "database_cleaner-active_record", "~> 2.2"
end
