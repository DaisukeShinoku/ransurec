FactoryBot.define do
  factory :member do
    sequence(:name) { |n| "選手#{n}" }
  end
end
