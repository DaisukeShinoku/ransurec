require "rails_helper"

RSpec.describe "Matches", type: :request do
  describe "match#update" do
    let(:event) { create(:event) }
    let(:match) { create(:match, event: event) }

    context "有効なパラメータを送信した場合" do
      it "試合のスコアが更新されること" do
        expect do
          patch match_path(match), params: { match: { home_score: 21, away_score: 15 } }
        end.to change { match.reload.home_score }.to(21)
           .and change { match.reload.away_score }.to(15)

        expect(response).to have_http_status(:found)
        expect(flash[:notice]).to be_present
      end

      it "JSONリクエストの場合、JSON形式で成功レスポンスが返ること" do
        patch match_path(match),
              params: { match: { home_score: 21, away_score: 15 } },
              headers: { "Accept" => "application/json" }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include("application/json")

        json_response = response.parsed_body
        expect(json_response["status"]).to eq("ok")
        expect(json_response["match"]).to be_present
        expect(json_response["notice"]).to be_present
      end
    end

    context "無効なパラメータを送信した場合" do
      it "試合のスコアが更新されないこと" do
        # 無効なパラメータとして負のスコアを送信
        patch match_path(match), params: { match: { home_score: -1, away_score: -1 } }
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to be_present
      end

      it "JSONリクエストの場合、JSON形式でエラーレスポンスが返ること" do
        patch match_path(match),
              params: { match: { home_score: -1, away_score: -1 } },
              headers: { "Accept" => "application/json" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include("application/json")

        json_response = response.parsed_body
        expect(json_response["status"]).to eq("unprocessable_entity")
        expect(json_response["errors"]).to be_present
        expect(json_response["alert"]).to be_present
      end
    end
  end

  describe "match#rotate" do
    let(:event) { create(:event, match_format: "doubles") }
    let(:match) { create(:match, event: event, match_format: "doubles") }
    let(:players) { create_list(:player, 4, event: event) }

    before do
      # 4人のプレイヤーをマッチに関連付け
      create(:match_player, match: match, player: players[0], side: :home)
      create(:match_player, match: match, player: players[1], side: :home)
      create(:match_player, match: match, player: players[2], side: :away)
      create(:match_player, match: match, player: players[3], side: :away)
    end

    context "HTMLリクエストの場合" do
      it "プレイヤーがローテーションされ、イベント詳細ページにリダイレクトされること" do
        # プレイヤーIDを取得
        original_player_ids = match.match_players.order(:id).pluck(:player_id)

        # ローテーションリクエストを送信
        post rotate_match_path(match)

        # リダイレクトを確認
        expect(response).to redirect_to(event_path(event))
        expect(flash[:notice]).to eq(I18n.t("match.notices.rotated"))

        # プレイヤーがローテーションされていることを確認
        rotated_player_ids = match.reload.match_players.order(:id).pluck(:player_id)
        expect(rotated_player_ids[0]).to eq(original_player_ids[0]) # 固定プレイヤー
        expect(rotated_player_ids[1]).to eq(original_player_ids[3])
        expect(rotated_player_ids[2]).to eq(original_player_ids[1])
        expect(rotated_player_ids[3]).to eq(original_player_ids[2])
      end
    end

    context "Turbo Streamリクエストの場合" do
      it "プレイヤーがローテーションされ、Turbo Streamレスポンスが返ること" do
        # プレイヤーIDを取得
        original_player_ids = match.match_players.order(:id).pluck(:player_id)

        # ローテーションリクエストを送信（Turbo Stream形式で）
        post rotate_match_path(match), headers: { "Accept" => "text/vnd.turbo-stream.html" }

        # レスポンスを確認
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")

        # レスポンス内容にマッチIDが含まれていることを確認
        expect(response.body).to include("match_id_#{match.id}")

        # プレイヤーがローテーションされていることを確認
        rotated_player_ids = match.reload.match_players.order(:id).pluck(:player_id)
        expect(rotated_player_ids[0]).to eq(original_player_ids[0]) # 固定プレイヤー
        expect(rotated_player_ids[1]).to eq(original_player_ids[3])
        expect(rotated_player_ids[2]).to eq(original_player_ids[1])
        expect(rotated_player_ids[3]).to eq(original_player_ids[2])
      end
    end

    context "シングルスの試合の場合" do
      let(:singles_match) { create(:match, event: event, match_format: "singles") }
      let(:singles_players) { create_list(:player, 2, event: event) }

      before do
        create(:match_player, match: singles_match, player: singles_players[0], side: :home)
        create(:match_player, match: singles_match, player: singles_players[1], side: :away)
      end

      it "プレイヤーがローテーションされないこと" do
        original_player_ids = singles_match.match_players.order(:id).pluck(:player_id)

        post rotate_match_path(singles_match)

        expect(singles_match.reload.match_players.order(:id).pluck(:player_id)).to eq(original_player_ids)
      end
    end
  end
end
