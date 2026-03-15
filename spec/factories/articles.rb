FactoryBot.define do
  factory :article do
    title   { Faker::Lorem.sentence(word_count: 5) }
    content { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    status  { :published }
    association :author, factory: :user
    association :section

    trait :draft do
      status { :draft }
    end
  end
end
