FactoryBot.define do
  factory :bookmark do
    association :user
    association :article
  end
end
