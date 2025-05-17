require "rails_helper"

RSpec.describe Player, type: :model do
  describe "勝率計算" do
    it "勝利数 / 勝利数+敗北数 で計算されること" do
      event = create(:event)
      player = create(:player, event:)
      first_match = create(:match, home_score: 4, away_score: 1, event:)
      second_match = create(:match, home_score: 2, away_score: 4, event:)
      third_match = create(:match, home_score: 3, away_score: 5, event:)
      forth_match = create(:match, home_score: 5, away_score: 4, event:)
      fifth_match = create(:match, home_score: 0, away_score: 0, event:)
      create(:match_player, player:, match: first_match, side: :home)
      create(:match_player, player:, match: second_match, side: :away)
      create(:match_player, player:, match: third_match, side: :home)
      create(:match_player, player:, match: forth_match, side: :home)
      create(:match_player, player:, match: fifth_match, side: :home)

      expect(player.wins_count).to eq(3)
      expect(player.losses_count).to eq(1)
      expect(player.win_rate).to eq(0.75)
    end

    it "勝利数+敗北数が0のときは0を返すこと" do
      event = create(:event)
      player = create(:player, event:)
      first_match = create(:match, home_score: 0, away_score: 0, event:)
      second_match = create(:match, home_score: 0, away_score: 0, event:)
      create(:match_player, player:, match: first_match, side: :home)
      create(:match_player, player:, match: second_match, side: :away)

      expect(player.wins_count).to eq(0)
      expect(player.losses_count).to eq(0)
      expect(player.win_rate).to eq(0)
    end
  end

  describe "取得ゲーム率計算" do
    it "得ゲーム数 / 得ゲーム数+失ゲーム数 で計算されること" do
      event = create(:event)
      player = create(:player, event:)
      first_match = create(:match, home_score: 4, away_score: 1, event:)
      second_match = create(:match, home_score: 2, away_score: 4, event:)
      third_match = create(:match, home_score: 3, away_score: 5, event:)
      forth_match = create(:match, home_score: 5, away_score: 4, event:)
      fifth_match = create(:match, home_score: 0, away_score: 0, event:)
      create(:match_player, player:, match: first_match, side: :home)
      create(:match_player, player:, match: second_match, side: :away)
      create(:match_player, player:, match: third_match, side: :home)
      create(:match_player, player:, match: forth_match, side: :home)
      create(:match_player, player:, match: fifth_match, side: :home)

      expect(player.games_won).to eq(16)
      expect(player.games_lost).to eq(12)
      expect(player.game_win_rate).to eq(0.571)
    end

    it "得ゲーム数+失ゲーム数が0のときは0を返すこと" do
      event = create(:event)
      player = create(:player, event:)
      first_match = create(:match, home_score: 0, away_score: 0, event:)
      second_match = create(:match, home_score: 0, away_score: 0, event:)
      create(:match_player, player:, match: first_match, side: :home)
      create(:match_player, player:, match: second_match, side: :away)

      expect(player.games_won).to eq(0)
      expect(player.games_lost).to eq(0)
      expect(player.game_win_rate).to eq(0)
    end
  end

  describe ".insert_all_default_players" do
    let(:event) { create(:event) }
    let(:number_of_players) { 5 }

    it "イベントに紐付いて「選手n」という名前で選手が作成されること" do
      described_class.insert_all_default_players(event: event, number_of_players: number_of_players)
      players = described_class.where(event: event)

      expect(players.count).to eq(number_of_players)
      players.each_with_index do |player, index|
        expect(player.display_name).to eq("選手#{index + 1}")
        expect(player.event_id).to eq(event.id)
      end
    end
  end
 end
