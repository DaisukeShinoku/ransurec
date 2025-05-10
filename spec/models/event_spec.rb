require "rails_helper"

RSpec.describe Event, type: :model do
  describe "#player_standings" do
    context "シングルスの場合" do
      let(:event) { create(:event, match_format: :singles) }
      let!(:player1) { create(:player, event: event, display_name: "選手1") }
      let!(:player2) { create(:player, event: event, display_name: "選手2") }
      let!(:player3) { create(:player, event: event, display_name: "選手3") }
      let!(:player4) { create(:player, event: event, display_name: "選手4") }

      before do
        # 選手1: 2勝1敗 (ゲーム: 16-13)
        # 選手2: 2勝1敗 (ゲーム: 16-13)
        # 選手3: 2勝1敗 (ゲーム: 16-13)
        # 選手4: 0勝3敗 (ゲーム: 9-18)

        # 第1試合 選手1(6) vs 選手2(4)
        match = create(:match, event: event, home_score: 6, away_score: 4)
        create(:match_player, match: match, player: player1, side: :home)
        create(:match_player, match: match, player: player2, side: :away)

        # 第2試合 選手3(6) vs 選手4(3)
        match = create(:match, event: event, home_score: 6, away_score: 3)
        create(:match_player, match: match, player: player3, side: :home)
        create(:match_player, match: match, player: player4, side: :away)

        # 第3試合 選手1(0) vs 選手3(6)
        match = create(:match, event: event, home_score: 4, away_score: 6)
        create(:match_player, match: match, player: player1, side: :home)
        create(:match_player, match: match, player: player3, side: :away)

        # 第4試合 選手2(6) vs 選手4(3)
        match = create(:match, event: event, home_score: 6, away_score: 3)
        create(:match_player, match: match, player: player2, side: :home)
        create(:match_player, match: match, player: player4, side: :away)

        # 第5試合 選手1(6) vs 選手4(3)
        match = create(:match, event: event, home_score: 6, away_score: 3)
        create(:match_player, match: match, player: player1, side: :home)
        create(:match_player, match: match, player: player4, side: :away)

        # 第6試合 選手3(4) vs 選手2(6)
        match = create(:match, event: event, home_score: 4, away_score: 6)
        create(:match_player, match: match, player: player3, side: :home)
        create(:match_player, match: match, player: player2, side: :away)
      end

      it "正しい順位で選手の成績を返すこと" do
        standings = event.player_standings

        expect(standings.size).to eq(4)

        # 1位: 選手1, 選手2, 選手3
        expect(standings[0][:id]).to eq(player1.id)
        expect(standings[0][:name]).to eq("選手1")
        expect(standings[0][:wins]).to eq(2)
        expect(standings[0][:losses]).to eq(1)
        expect(standings[0][:win_rate]).to eq(0.667)
        expect(standings[0][:rank]).to eq(1)

        expect(standings[1][:id]).to eq(player2.id)
        expect(standings[1][:name]).to eq("選手2")
        expect(standings[1][:wins]).to eq(2)
        expect(standings[1][:losses]).to eq(1)
        expect(standings[1][:win_rate]).to eq(0.667)
        expect(standings[1][:rank]).to eq(1)

        expect(standings[2][:id]).to eq(player3.id)
        expect(standings[2][:name]).to eq("選手3")
        expect(standings[2][:wins]).to eq(2)
        expect(standings[2][:losses]).to eq(1)
        expect(standings[2][:win_rate]).to eq(0.667)
        expect(standings[2][:rank]).to eq(1)

        # 4位: 選手4
        expect(standings[3][:id]).to eq(player4.id)
        expect(standings[3][:name]).to eq("選手4")
        expect(standings[3][:wins]).to eq(0)
        expect(standings[3][:losses]).to eq(3)
        expect(standings[3][:win_rate]).to eq(0)
        expect(standings[3][:rank]).to eq(4)
      end
    end

    context "ダブルスの場合" do
      let(:event) { create(:event, match_format: :singles) }
      let!(:player1) { create(:player, event: event, display_name: "選手1") }
      let!(:player2) { create(:player, event: event, display_name: "選手2") }
      let!(:player3) { create(:player, event: event, display_name: "選手3") }
      let!(:player4) { create(:player, event: event, display_name: "選手4") }
      let!(:player5) { create(:player, event: event, display_name: "選手5") }

      before do
        # 選手1: 4勝3敗 (ゲーム: 38-35)
        # 選手2: 2勝4敗 (ゲーム: 28-33)
        # 選手3: 4勝3敗 (ゲーム: 38-35)
        # 選手4: 2勝4敗 (ゲーム: 28-33)
        # 選手5: 4勝2敗 (ゲーム: 34-30)

        # 第1試合 選手1,2(6) vs 選手3,4(4)
        match = create(:match, event: event, home_score: 6, away_score: 4)
        create(:match_player, match: match, player: player1, side: :home)
        create(:match_player, match: match, player: player2, side: :home)
        create(:match_player, match: match, player: player3, side: :away)
        create(:match_player, match: match, player: player4, side: :away)

        # 第2試合 選手5,1(4) vs 選手2,3(6)
        match = create(:match, event: event, home_score: 4, away_score: 6)
        create(:match_player, match: match, player: player5, side: :home)
        create(:match_player, match: match, player: player1, side: :home)
        create(:match_player, match: match, player: player2, side: :away)
        create(:match_player, match: match, player: player3, side: :away)

        # 第3試合 選手4,5(6) vs 選手1,3(4)
        match = create(:match, event: event, home_score: 6, away_score: 4)
        create(:match_player, match: match, player: player4, side: :home)
        create(:match_player, match: match, player: player5, side: :home)
        create(:match_player, match: match, player: player1, side: :away)
        create(:match_player, match: match, player: player3, side: :away)

        # 第4試合 選手2,4(4) vs 選手5,3(6)
        match = create(:match, event: event, home_score: 4, away_score: 6)
        create(:match_player, match: match, player: player2, side: :home)
        create(:match_player, match: match, player: player4, side: :home)
        create(:match_player, match: match, player: player5, side: :away)
        create(:match_player, match: match, player: player3, side: :away)

        # 第5試合 選手1,4(6) vs 選手2,5(4)
        match = create(:match, event: event, home_score: 6, away_score: 4)
        create(:match_player, match: match, player: player1, side: :home)
        create(:match_player, match: match, player: player4, side: :home)
        create(:match_player, match: match, player: player2, side: :away)
        create(:match_player, match: match, player: player5, side: :away)

        # 第6試合 選手3,1(6) vs 選手2,4(3)
        match = create(:match, event: event, home_score: 6, away_score: 3)
        create(:match_player, match: match, player: player3, side: :home)
        create(:match_player, match: match, player: player1, side: :home)
        create(:match_player, match: match, player: player2, side: :away)
        create(:match_player, match: match, player: player4, side: :away)

        # 第7試合 選手5,3(7) vs 選手1,2(5)
        match = create(:match, event: event, home_score: 7, away_score: 5)
        create(:match_player, match: match, player: player5, side: :home)
        create(:match_player, match: match, player: player3, side: :home)
        create(:match_player, match: match, player: player1, side: :away)
        create(:match_player, match: match, player: player2, side: :away)

        # 第8試合 選手4,3(5) vs 選手5,1(7)
        match = create(:match, event: event, home_score: 5, away_score: 7)
        create(:match_player, match: match, player: player4, side: :home)
        create(:match_player, match: match, player: player3, side: :home)
        create(:match_player, match: match, player: player5, side: :away)
        create(:match_player, match: match, player: player1, side: :away)
      end

      it "正しい順位で選手の成績を返すこと" do
        standings = event.player_standings

        expect(standings.size).to eq(5)

        # 1位: 選手5
        expect(standings[0][:id]).to eq(player5.id)
        expect(standings[0][:name]).to eq("選手5")
        expect(standings[0][:wins]).to eq(4)
        expect(standings[0][:losses]).to eq(2)
        expect(standings[0][:win_rate]).to eq(0.667)
        expect(standings[0][:rank]).to eq(1)

        # 2位: 選手1, 選手3
        expect(standings[1][:id]).to eq(player1.id)
        expect(standings[1][:name]).to eq("選手1")
        expect(standings[1][:wins]).to eq(4)
        expect(standings[1][:losses]).to eq(3)
        expect(standings[1][:win_rate]).to eq(0.571)
        expect(standings[1][:rank]).to eq(2)

        expect(standings[2][:id]).to eq(player3.id)
        expect(standings[2][:name]).to eq("選手3")
        expect(standings[2][:wins]).to eq(4)
        expect(standings[2][:losses]).to eq(3)
        expect(standings[2][:win_rate]).to eq(0.571)
        expect(standings[2][:rank]).to eq(2)

        # 4位: 選手2, 選手4
        expect(standings[3][:id]).to eq(player2.id)
        expect(standings[3][:name]).to eq("選手2")
        expect(standings[3][:wins]).to eq(2)
        expect(standings[3][:losses]).to eq(4)
        expect(standings[3][:win_rate]).to eq(0.333)
        expect(standings[3][:rank]).to eq(4)

        expect(standings[4][:id]).to eq(player4.id)
        expect(standings[4][:name]).to eq("選手4")
        expect(standings[4][:wins]).to eq(2)
        expect(standings[4][:losses]).to eq(4)
        expect(standings[4][:win_rate]).to eq(0.333)
        expect(standings[4][:rank]).to eq(4)
      end
    end
  end

  describe "#matches_grouped_by_sequence" do
    let(:event) { create(:event) }

    context "複数の試合順を持つマッチが存在する場合" do
      before do
        create(:match, event: event, sequence_num: 1, coat_num: 1)
        create(:match, event: event, sequence_num: 1, coat_num: 2)

        create(:match, event: event, sequence_num: 2, coat_num: 1)
        create(:match, event: event, sequence_num: 2, coat_num: 2)

        create(:match, event: event, sequence_num: 3, coat_num: 1)
      end

      it "試合順でグループ化されたマッチのハッシュを返すこと" do
        result = event.matches_grouped_by_sequence

        expect(result).to be_a(Hash)

        expect(result.keys).to contain_exactly(1, 2, 3)
        expect(result[1].size).to eq(2)
        expect(result[2].size).to eq(2)
        expect(result[3].size).to eq(1)
      end

      it "コート番号でソートされていること" do
        result = event.matches_grouped_by_sequence

        expect(result[1].map(&:coat_num)).to eq([1, 2])

        expect(result[2].map(&:coat_num)).to eq([1, 2])
      end
    end

    context "試合が存在しない場合" do
      it "空のハッシュを返すこと" do
        result = event.matches_grouped_by_sequence
        expect(result).to be_empty
      end
    end
  end
end
