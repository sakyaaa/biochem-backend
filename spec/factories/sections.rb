FactoryBot.define do
  factory :section do
    name        { Faker::Lorem.word.capitalize }
    description { Faker::Lorem.sentence }
    slug        { name.downcase.gsub(/\s+/, "-") }
  end
end
