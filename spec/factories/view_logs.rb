FactoryBot.define do
  factory :view_log do
    user    { nil }
    association :article
  end
end
