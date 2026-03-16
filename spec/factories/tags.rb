FactoryBot.define do
  factory :tag do
    name { Faker::Lorem.unique.word.capitalize }
  end
end
