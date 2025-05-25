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
          patch update_all_players_path, params: valid_params, headers: { "Accept" => "text/vnd.turbo-stream.html" }
        end.to change { player1.reload.display_name }.to("新しい選手名1")
           .and change { player2.reload.display_name }.to("新しい選手名2")

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include(I18n.t("player.notices.updated"))
        expect(response.body).to include('turbo-stream action="update" target="flash-messages"')
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
    end
  end

  describe "GET show_player_name_dialog_players_path" do
    let(:event) { create(:event) }

    before do
      create(:player, event: event, display_name: "Player A")
      create(:player, event: event, display_name: "Player B")
    end

    context "event_idパラメータのみがある場合" do
      it "成功のレスポンスを返すこと" do
        get show_player_name_dialog_players_path(event_id: event.id), headers: { Accept: "text/vnd.turbo-stream.html" }
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "レスポンスボディにTurbo Streamアクションが含まれること" do
        get show_player_name_dialog_players_path(event_id: event.id), headers: { Accept: "text/vnd.turbo-stream.html" }

        expect(response.body).to include('<turbo-stream action="replace" target="name_edit_dialog">')
        expect(response.body).to include('<h3 class="text-lg font-medium text-gray-900')
        expect(response.body).to include("選手名を編集</h3>")
        expect(response.body).to include('action="/players/update_all"')
        expect(response.body).to include('method="post"')
        expect(response.body).to include('data-turbo-stream="true"')
        expect(response.body).to include("<form")
        expect(response.body).to include('value="Player A"')
        expect(response.body).to include('value="Player B"')
        expect(response.body).to include('name="commit" value="一括更新"')
      end

      it "レスポンスボディにstatusがデフォルト値の'block'で反映されていること" do
        get show_player_name_dialog_players_path(event_id: event.id), headers: { Accept: "text/vnd.turbo-stream.html" }
        expect(response.body).to include('style="display: block;"')
      end
    end
  end
end
