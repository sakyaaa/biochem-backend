# frozen_string_literal: true

FactoryBot.define do
  factory :section do
    name        { Faker::Lorem.unique.word.capitalize }
    description { Faker::Lorem.sentence }
    slug        { "#{name.downcase.gsub(/\s+/, '-')}-#{SecureRandom.hex(4)}" }
  end
end
