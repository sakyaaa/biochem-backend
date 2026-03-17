# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS pg_trgm')
  rescue ActiveRecord::StatementInvalid
    # расширение недоступно — тесты с trigram будут пропущены
  end

  config.after(:each) do
    Faker::UniqueGenerator.clear
  end
end
