class Player < ApplicationRecord
  belongs_to :meetup
  has_many :game_players, dependent: :destroy
  has_many :games, through: :game_players, dependent: :destroy

  validates :display_name, presence: true, length: { maximum: 10 }

  class << self
    def insert_all_default_players(meetup:, number_of_players:)
      players = []
      number_of_players.times do |player|
        players << { meetup_id: meetup.id, display_name: "選手#{player + 1}" }
      end
      Player.insert_all!(players) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
