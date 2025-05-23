require "rails_helper"

RSpec.describe "Players", type: :request do
  describe "players#update_all" do
    let(:event) { create(:event) }
    let!(:player1) { create(:player, event: event) }
    let!(:player2) { create(:player, event: event) }

    context "有効なパラメータを送信した場合" do
      let(:valid_params) do
        {
          event_id: event.id,
          players: {
            player1.id => { display_name: "新しい選手名1" },
            player2.id => { display_name: "新しい選手名2" }
          }
        }
      end

      it "選手の表示名が更新されること" do
        expect do
          patch update_all_players_path, params: valid_params
        end.to change { player1.reload.display_name }.to("新しい選手名1")
           .and change { player2.reload.display_name }.to("新しい選手名2")

        expect(response).to have_http_status(:found)
        expect(flash[:notice]).to be_present
      end

      it "JSONリクエストの場合、JSON形式で成功レスポンスが返ること" do
        patch update_all_players_path,
              params: valid_params,
              headers: { "Accept" => "application/json" }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include("application/json")

        json_response = response.parsed_body
        expect(json_response["status"]).to eq("ok")
        expect(json_response["notice"]).to be_present
      end
    end

    context "無効なパラメータを送信した場合" do
      let(:invalid_params) do
        {
          event_id: event.id,
          players: {
            player1.id => { display_name: "" },
            player2.id => { display_name: "a" * 11 } # 10文字以上は無効
          }
        }
      end

      it "選手の表示名が更新されないこと" do
        original_name1 = player1.display_name
        original_name2 = player2.display_name

        patch update_all_players_path, params: invalid_params

        expect(player1.reload.display_name).to eq(original_name1)
        expect(player2.reload.display_name).to eq(original_name2)
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to be_present
      end

      it "JSONリクエストの場合、JSON形式でエラーレスポンスが返ること" do
        patch update_all_players_path,
              params: invalid_params,
              headers: { "Accept" => "application/json" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include("application/json")

        json_response = response.parsed_body
        expect(json_response["status"]).to eq("error")
        expect(json_response["alert"]).to be_present
      end
    end
  end

  describe "GET show_player_name_dialog_players_path" do
    let(:event) { create(:event) }
    let!(:player1) { create(:player, event: event, display_name: "Player A") }
    let!(:player2) { create(:player, event: event, display_name: "Player B") }

    context "event_idパラメータのみがある場合" do
      it "成功のレスポンスを返すこと" do
        get show_player_name_dialog_players_path(event_id: event.id), headers: { "Accept": "text/vnd.turbo-stream.html" }
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "レスポンスボディにTurbo Streamアクションが含まれること" do
        get show_player_name_dialog_players_path(event_id: event.id), headers: { "Accept": "text/vnd.turbo-stream.html" }

        expect(response.body).to include('<turbo-stream action="replace" target="name_edit_dialog">')
        expect(response.body).to include('<h3 class="text-lg font-medium text-gray-900 mb-4 sticky top-0 bg-white py-2">選手名を編集</h3>') # 例: パーシャル内のH3タグのテキスト
        expect(response.body).to include('<form class="space-y-4" data-turbo-stream="true" action="/players/update_all" accept-charset="UTF-8" method="post">') # フォームの開始タグ
        expect(response.body).to include('value="Player A"')
        expect(response.body).to include('value="Player B"')
        expect(response.body).to include('name="commit" value="一括更新"')
      end

      it "レスポンスボディにstatusがデフォルト値の'block'で反映されていること" do
        get show_player_name_dialog_players_path(event_id: event.id), headers: { "Accept": "text/vnd.turbo-stream.html" }
        expect(response.body).to include('style="display: block;"')
      end
    end
  end
end
