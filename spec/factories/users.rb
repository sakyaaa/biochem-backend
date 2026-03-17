# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name     { Faker::Name.name }
    email    { Faker::Internet.unique.email }
    password { 'Password123!' }
    role     { :member }
    jti      { SecureRandom.uuid }

    trait :editor do
      role { :editor }
    end

    trait :admin do
      role { :admin }
    end
  end
end
