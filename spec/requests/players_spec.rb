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

  describe "GET show_player_name_dialog_players_path" do # describe の内容は正しい
    let(:event) { create(:event) }
    let(:player) { create(:player, event: event) } # 必要に応じて

    context 'パラメータにevent_idのみがある場合' do
      it '指定されたイベントを@eventに割り当て、成功のレスポンスを返すこと' do
        get show_player_name_dialog_players_path, params: { event_id: event.id, format: :turbo_stream } # ここを修正

        expect(response).to have_http_status(:ok)
        expect(assigns(:event)).to eq(event)
        expect(assigns(:status)).to eq("block")
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
        expect(response.body).to include('<turbo-stream action="replace" target="name_edit_dialog">')
        expect(response).to render_template(partial: 'players/_name_edit_dialog')
        expect(response).to render_template(locals: { event: event, status: "block" })
      end
    end

    context 'パラメータにevent_idとstatusがある場合' do
      it '@statusにパラメータのstatusの値を割り当てること' do
        get show_player_name_dialog_players_path, params: { event_id: event.id, status: "none", format: :turbo_stream } # ここを修正

        expect(response).to have_http_status(:ok)
        expect(assigns(:status)).to eq("none")
        expect(response).to render_template(locals: { event: event, status: "none" })
      end
    end

    context '無効なevent_idが渡された場合' do
      it 'ActiveRecord::RecordNotFoundエラーが発生し、404レスポンスを返すこと' do
        expect {
          get show_player_name_dialog_players_path, params: { event_id: 999, format: :turbo_stream } # ここを修正
        }.to raise_error(ActiveRecord::RecordNotFound)
        # エラーが発生するため、以下のexpectは実行されません
        # expect(response).to have_http_status(:not_found)
      end
    end
  end
end
