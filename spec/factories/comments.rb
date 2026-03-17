# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body      { Faker::Lorem.sentence(word_count: 10) }
    approved  { true }
    association :user
    association :article

    trait :pending do
      approved { false }
    end
  end
end
