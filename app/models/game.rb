class Game < ApplicationRecord
  belongs_to :meetup
  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players, dependent: :destroy

  validates :coat_num, presence: true, numericality: { only_integer: true, greater_than: 0 }
  enum :game_format, { singles: 1, doubles: 2 }, validate: true

  class << self
    def insert_all_default_games(meetup:)
      games = []

      game_format = meetup.game_format
      number_of_coats = meetup.number_of_coats
      number_of_players = meetup.players.size

      key = "coat#{number_of_coats}_player#{number_of_players}"
      file_path = "config/random_number_table/#{game_format}/#{key}.yml"
      random_number_table = YAML.load_file(file_path)

      random_number_table.each_with_index do |_, sequence_num|
        number_of_coats.times do |coat_num|
          games << { meetup_id: meetup.id, coat_num: coat_num + 1, sequence_num: sequence_num + 1, game_format: }
        end
      end

      Game.insert_all!(games) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
