FactoryBot.define do
  factory :match_player do
    side { %i[home away].sample }
  end
end
