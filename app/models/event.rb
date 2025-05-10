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

    sorted_stats = player_stats.sort_by { |stats| [-stats[:win_rate], -stats[:game_win_rate]] }

    # 順位を割り当てる
    return [] if sorted_stats.empty?

    current_rank = 1
    sorted_stats[0][:rank] = current_rank

    # 同じ順位の人数をカウント（スキップする数を計算するため）
    same_rank_count = 1

    (1...sorted_stats.size).each do |i|
      current = sorted_stats[i]
      previous = sorted_stats[i - 1]

      if current[:win_rate] == previous[:win_rate] && current[:game_win_rate] == previous[:game_win_rate]
        # 前の選手と同じ勝率・ゲーム取得率なら同じ順位を割り当てる
        current[:rank] = current_rank
        same_rank_count += 1
      else
        # そうでなければ、同順位だった人数分スキップした順位を割り当てる
        current_rank += same_rank_count
        current[:rank] = current_rank
        same_rank_count = 1
      end
    end

    sorted_stats
  end
end
