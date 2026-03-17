# frozen_string_literal: true

FactoryBot.define do
  factory :view_log do
    user { nil }
    association :article
  end
end
