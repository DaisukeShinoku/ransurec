require "rails_helper"

RSpec.describe Game, type: :model do
  describe ".insert_all_default_games" do
    let(:meetup) { create(:meetup, game_format:, number_of_coats:) }

    before do
      create_list(:player, number_of_players, meetup:)
    end

    context "シングルスの場合" do
      let(:game_format) { "singles" }

      context "コートが1面の場合" do
        let(:number_of_coats) { 1 }

        context "選手が7人の場合" do
          let(:number_of_players) { 7 }

          it "ミートアップに紐付いて21試合が作成されること" do
            expect { described_class.insert_all_default_games(meetup: meetup) }.to change(described_class, :count).by(21)
          end
        end
      end

      context "コートが2面の場合" do
        let(:number_of_coats) { 2 }

        context "選手が15人の場合" do
          let(:number_of_players) { 15 }

          it "イベントに紐付いて、コート1とコート2で30試合ずつ作成されること" do
            expect { described_class.insert_all_default_games(meetup: meetup) }
              .to change(described_class.where(coat_num: 1), :count).by(30)
              .and change(described_class.where(coat_num: 2), :count).by(30)
          end
        end
      end
    end

    context "ダブルスの場合" do
      let(:game_format) { "doubles" }

      context "コートが1面の場合" do
        let(:number_of_coats) { 1 }

        context "選手が5人の場合" do
          let(:number_of_players) { 5 }

          it "イベントに紐付いて30試合が作成されること" do
            expect { described_class.insert_all_default_games(meetup: meetup) }.to change(described_class, :count).by(30)
          end
        end
      end

      context "コートが2面の場合" do
        let(:number_of_coats) { 2 }

        context "選手が13人の場合" do
          let(:number_of_players) { 13 }

          it "ミートアップに紐付いて、コート1とコート2で30試合ずつ作成されること" do
            expect { described_class.insert_all_default_games(meetup: meetup) }
              .to change(described_class.where(coat_num: 1), :count).by(30)
              .and change(described_class.where(coat_num: 2), :count).by(30)
          end
        end
      end
    end
  end
end
