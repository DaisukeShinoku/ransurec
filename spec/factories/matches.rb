FactoryBot.define do
  factory :match do
    coat_num { rand(1..2) }
    sequence(:sequence_num) { |n| n }
    match_format { rand(1..2) }
    home_score { rand(0..6) }
    away_score { rand(0..6) }
  end
end
