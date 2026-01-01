require "rails_helper"

RSpec.describe GamePlayer, type: :model do
  describe ".insert_all_default_game_players" do
    let(:meetup) { create(:meetup, game_format:, number_of_coats:) }

    before do
      # MEMO: 本来、別モデルのメソッドを呼び出すのは避けるべきだが他にテストをする方法が思いつかないため許容する
      Player.insert_all_default_players(meetup:, number_of_players:)
      Game.insert_all_default_games(meetup:)
    end

    context "シングルスの場合" do
      let(:game_format) { "singles" }

      context "コートが1面の場合" do
        let(:number_of_coats) { 1 }

        context "選手が7人の場合" do
          let(:number_of_players) { 7 }

          it "第11順の試合の組み合わせが[6]vs[1]であること" do
            described_class.insert_all_default_game_players(meetup: meetup)

            game = Game.find_by(sequence_num: 11, coat_num: 1)

            home_player_names = game.game_players.where(side: "home").map { it.player.display_name }
            away_player_names = game.game_players.where(side: "away").map { it.player.display_name }

            expect(home_player_names).to eq(["選手6"])
            expect(away_player_names).to eq(["選手1"])
          end
        end
      end

      context "コートが2面の場合" do
        let(:number_of_coats) { 2 }

        context "選手が15人の場合" do
          let(:number_of_players) { 15 }

          it "第29順第2コートの試合の組み合わせが[5]vs[8]であること" do
            described_class.insert_all_default_game_players(meetup: meetup)

            game = Game.find_by(sequence_num: 29, coat_num: 2)

            home_player_names = game.game_players.where(side: "home").map { it.player.display_name }
            away_player_names = game.game_players.where(side: "away").map { it.player.display_name }

            expect(home_player_names).to eq(["選手5"])
            expect(away_player_names).to eq(["選手8"])
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

          it "第14順の試合の組み合わせが[2,4]vs[5,3]であること" do
            described_class.insert_all_default_game_players(meetup: meetup)

            game = Game.find_by(sequence_num: 14, coat_num: 1)

            home_player_names = game.game_players.where(side: "home").map { it.player.display_name }
            away_player_names = game.game_players.where(side: "away").map { it.player.display_name }

            expect(home_player_names).to eq(%w[選手2 選手4])
            expect(away_player_names).to eq(%w[選手5 選手3])
          end
        end
      end

      context "コートが2面の場合" do
        let(:number_of_coats) { 2 }

        context "選手が13人の場合" do
          let(:number_of_players) { 13 }

          it "第27順第2コートの試合の組み合わせが[5,9]vs[7,8]であること" do
            described_class.insert_all_default_game_players(meetup: meetup)

            game = Game.find_by(sequence_num: 27, coat_num: 2)

            home_player_names = game.game_players.where(side: "home").map { it.player.display_name }
            away_player_names = game.game_players.where(side: "away").map { it.player.display_name }

            expect(home_player_names).to eq(%w[選手5 選手9])
            expect(away_player_names).to eq(%w[選手7 選手8])
          end
        end
      end
    end
  end
end
