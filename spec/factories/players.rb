FactoryBot.define do
  factory :player do
    sequence(:name) { |n| "選手#{n}" }
  end
end
