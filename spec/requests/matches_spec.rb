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
end
