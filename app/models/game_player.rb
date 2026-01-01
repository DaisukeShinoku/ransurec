class GamePlayer < ApplicationRecord
  belongs_to :game
  belongs_to :player

  enum :side, { home: 1, away: 2 }, validate: true

  class << self
    def insert_all_default_game_players(meetup:)
      game_players = []

      all_games = meetup.games
      all_players = meetup.players
      game_format = meetup.game_format
      number_of_coats = meetup.number_of_coats
      number_of_players = all_players.size

      key = "coat#{number_of_coats}_player#{number_of_players}"
      file_path = "config/random_number_table/#{game_format}/#{key}.yml"
      random_number_table = YAML.load_file(file_path)

      coat_side_array = %w[home away]

      all_games.each do |game|
        coat_side_array.each do |side|
          player_nums = random_number_table["sequence#{game.sequence_num}"]["coat#{game.coat_num}"][side]
          player_nums.each do |player_num|
            player = all_players.find { it.display_name == "選手#{player_num}" }
            game_players << { game_id: game.id, player_id: player.id, side: side }
          end
        end
      end

      GamePlayer.insert_all!(game_players) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
