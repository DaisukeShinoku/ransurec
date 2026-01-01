FactoryBot.define do
  factory :match_player do
    side { rand(1..2) }
  end
end
