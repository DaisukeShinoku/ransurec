FactoryBot.define do
  factory :meetup do
    sequence(:name) { |n| "ミートアップ #{n}" }
    match_format { rand(1..2) }
    number_of_coats { rand(1..2) }
  end
end
