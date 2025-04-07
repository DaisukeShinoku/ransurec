class Player < ApplicationRecord
  belongs_to :event
  has_many :match_players, dependent: :destroy
  has_many :matches, through: :match_players, dependent: :destroy

  validates :display_name, presence: true, length: { maximum: 10 }

  class << self
    def insert_all_default_players(event:, number_of_players:)
      players = []
      number_of_players.times do |player|
        players << { event_id: event.id, display_name: "選手#{player + 1}" }
      end
      Player.insert_all!(players) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
