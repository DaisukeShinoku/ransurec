FactoryBot.define do
  factory :event do
    sequence(:name) { |n| "イベント #{n}" }
    match_format { rand(1..2) }
    number_of_coats { rand(1..2) }
  end
end
