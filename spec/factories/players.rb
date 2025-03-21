FactoryBot.define do
  factory :player do
    sequence(:display_name) { |n| "選手#{n}" }
  end
end
