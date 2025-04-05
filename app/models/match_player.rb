class MatchPlayer < ApplicationRecord
  belongs_to :match
  belongs_to :player

  enum :side, { home: 1, away: 2 }, validate: true

  class << self
    def insert_all_default_match_players(event:)
      match_players = []

      all_matches = event.matches
      all_players = event.players
      match_format = event.match_format
      number_of_coats = event.number_of_coats
      number_of_players = all_players.size

      key = "coat#{number_of_coats}_player#{number_of_players}"
      file_path = "config/random_number_table/#{match_format}/#{key}.yml"
      random_number_table = YAML.load_file(file_path)

      coat_side_array = %w[home away]

      all_matches.each do |match|
        coat_side_array.each do |side|
          player_nums = random_number_table["sequence#{match.sequence_num}"]["coat#{match.coat_num}"][side]
          player_nums.each do |player_num|
            player = all_players.find { it.display_name == "選手#{player_num}" }
            match_players << { match_id: match.id, player_id: player.id, side: side }
          end
        end
      end

      MatchPlayer.insert_all!(match_players) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
