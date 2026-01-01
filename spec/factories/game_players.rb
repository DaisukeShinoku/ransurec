FactoryBot.define do
  factory :game_player do
    side { rand(1..2) }
  end
end
