class Player < ApplicationRecord
  belongs_to :event
  has_many :match_players, dependent: :destroy
  has_many :matches, through: :match_players, dependent: :destroy

  validates :display_name, presence: true, length: { maximum: 10 }

  def wins_count
    match_players.joins(:match).where(
      'matches.home_score > matches.away_score AND match_players.side = ? OR
       matches.away_score > matches.home_score AND match_players.side = ?',
      MatchPlayer.sides[:home], MatchPlayer.sides[:away]
    ).count
  end

  def losses_count
    match_players.joins(:match).where(
      'matches.home_score < matches.away_score AND match_players.side = ? OR
       matches.away_score < matches.home_score AND match_players.side = ?',
      MatchPlayer.sides[:home], MatchPlayer.sides[:away]
    ).count
  end

  def win_rate
    total = wins_count + losses_count
    return 0 if total.zero?

    (wins_count.to_f / total).round(3)
  end

  def games_won
    home_games = match_players.joins(:match)
                              .where(side: MatchPlayer.sides[:home])
                              .sum("matches.home_score")
    away_games = match_players.joins(:match)
                              .where(side: MatchPlayer.sides[:away])
                              .sum("matches.away_score")
    home_games + away_games
  end

  def games_lost
    home_games = match_players.joins(:match)
                              .where(side: MatchPlayer.sides[:home])
                              .sum("matches.away_score")
    away_games = match_players.joins(:match)
                              .where(side: MatchPlayer.sides[:away])
                              .sum("matches.home_score")
    home_games + away_games
  end

  def game_win_rate
    total = games_won + games_lost
    return 0 if total.zero?

    (games_won.to_f / total).round(3)
  end

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
