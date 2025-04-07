class Match < ApplicationRecord
  belongs_to :event
  has_many :match_players, dependent: :destroy
  has_many :players, through: :match_players, dependent: :destroy
  has_many :home_players, -> { where(match_players: { side: :home }) }, through: :match_players, source: :player
  has_many :away_players, -> { where(match_players: { side: :away }) }, through: :match_players, source: :player

  validates :coat_num, presence: true, numericality: { only_integer: true, greater_than: 0 }
  enum :match_format, { singles: 1, doubles: 2 }, validate: true

  class << self
    def insert_all_default_matches(event:)
      matches = []

      match_format = event.match_format
      number_of_coats = event.number_of_coats
      number_of_players = event.players.size

      key = "coat#{number_of_coats}_player#{number_of_players}"
      file_path = "config/random_number_table/#{match_format}/#{key}.yml"
      random_number_table = YAML.load_file(file_path)

      random_number_table.each_with_index do |_, sequence_num|
        number_of_coats.times do |coat_num|
          matches << { event_id: event.id, coat_num: coat_num + 1, sequence_num: sequence_num + 1, match_format: }
        end
      end

      Match.insert_all!(matches) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
