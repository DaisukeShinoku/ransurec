require "rails_helper"

RSpec.describe Event::Launch, type: :model do
  describe "#save!" do
    let(:name) { "xx月xx日_練習" }

    context "正常系" do
      context "シングルスの場合" do
        let(:match_format) { "singles" }

        context "コートが1面の場合" do
          let(:number_of_coats) { 1 }
          let(:number_of_players) { 8 }

          it "イベント・選手・試合・試合_選手が作成されること" do
            launch = described_class.new(name:, match_format:, number_of_coats:, number_of_players:)
            launch.save!
            expect(Event.count).to eq(1)
            expect(Player.count).to eq(8)
            expect(Match.count).to eq(28)
            expect(MatchPlayer.count).to eq(56)
          end
        end

        context "コートが2面の場合" do
          let(:number_of_coats) { 2 }
          let(:number_of_players) { 16 }

          it "イベント・選手・試合・試合_選手が作成されること" do
            launch = described_class.new(name:, match_format:, number_of_coats:, number_of_players:)
            launch.save!
            expect(Event.count).to eq(1)
            expect(Player.count).to eq(16)
            expect(Match.count).to eq(60)
            expect(MatchPlayer.count).to eq(120)
          end
        end
      end

      context "ダブルスの場合" do
        let(:match_format) { "doubles" }

        context "コートが1面の場合" do
          let(:number_of_coats) { 1 }
          let(:number_of_players) { 8 }

          it "イベント・選手・試合・試合_選手が作成されること" do
            launch = described_class.new(name:, match_format:, number_of_coats:, number_of_players:)
            launch.save!
            expect(Event.count).to eq(1)
            expect(Player.count).to eq(8)
            expect(Match.count).to eq(30)
            expect(MatchPlayer.count).to eq(120)
          end
        end

        context "コートが2面の場合" do
          let(:number_of_coats) { 2 }
          let(:number_of_players) { 16 }

          it "イベント・選手・試合・試合_選手が作成されること" do
            launch = described_class.new(name:, match_format:, number_of_coats:, number_of_players:)
            launch.save!
            expect(Event.count).to eq(1)
            expect(Player.count).to eq(16)
            expect(Match.count).to eq(60)
            expect(MatchPlayer.count).to eq(240)
          end
        end
      end
    end

    context "異常系" do
      context "コート1面あたりの人数が8人を超える場合" do
        let(:match_format) { "doubles" }
        let(:number_of_coats) { 1 }
        let(:number_of_players) { 9 }

        it "falseを返すこと" do
          launch = described_class.new(name:, match_format:, number_of_coats:, number_of_players:)
          expect(launch.save!).to be_falsey
          expect(launch.errors.full_messages).to eq(["選手数は8以下の値にしてください"])
        end
      end

      context "ダブルスでコート1面あたりの人数が4人未満の場合" do
        let(:match_format) { "doubles" }
        let(:number_of_coats) { 2 }
        let(:number_of_players) { 3 }

        it "falseを返すこと" do
          launch = described_class.new(name:, match_format:, number_of_coats:, number_of_players:)
          expect(launch.save!).to be_falsey
          expect(launch.errors.full_messages).to eq(["選手数は8以上の値にしてください"])
        end
      end

      context "シングルスでコート1面あたりの人数が2人未満の場合" do
        let(:match_format) { "singles" }
        let(:number_of_coats) { 2 }
        let(:number_of_players) { 3 }

        it "falseを返すこと" do
          launch = described_class.new(name:, match_format:, number_of_coats:, number_of_players:)
          expect(launch.save!).to be_falsey
          expect(launch.errors.full_messages).to eq(["選手数は4以上の値にしてください"])
        end
      end
    end
  end
end
