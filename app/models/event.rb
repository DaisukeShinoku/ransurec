class Event < ApplicationRecord
  has_many :matches, dependent: :destroy
  has_many :players, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
  validates :number_of_coats, presence: true, numericality: { only_integer: true, greater_than: 0 }
  enum :match_format, { singles: 1, doubles: 2 }, validate: true

  def matches_grouped_by_sequence
    matches.order(:sequence_num, :coat_num).group_by(&:sequence_num)
  end

  def player_standings
    player_stats = players.map do |player|
      {
        id: player.id,
        name: player.display_name,
        wins: player.wins_count,
        losses: player.losses_count,
        win_rate: player.win_rate,
        games_won: player.games_won,
        games_lost: player.games_lost,
        game_win_rate: player.game_win_rate
      }
    end

    player_stats.sort_by { |stats| [-stats[:win_rate], -stats[:game_win_rate]] }
  end
end
