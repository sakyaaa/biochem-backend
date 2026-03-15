FactoryBot.define do
  factory :user do
    name     { Faker::Name.full_name }
    email    { Faker::Internet.unique.email }
    password { "Password123!" }
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
