require "rails_helper"

RSpec.describe "Events", type: :request do
  describe "event#show" do
    let(:event) { create(:event) }

    it "乱数表の詳細画面が表示されること" do
      get event_path(event)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(event.name)
    end
  end

  describe "event#new" do
    it "乱数表の作成画面が表示されること" do
      get root_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("乱数表の作成")
    end
  end

  describe "event#create" do
    context "有効なパラメータを送信した場合" do
      it "乱数表が作成されること" do
        expect do
          post events_path,
               params: { event_launch: { name: "テスト乱数表", match_format: :singles, number_of_coats: 2, number_of_players: 7 } }
        end.to change(Event, :count).by(1)
      end
    end

    context "無効なパラメータを送信した場合" do
      it "乱数表が作成されないこと" do
        expect do
          post events_path, params: { event_launch: { name: "", match_format: :hoge, number_of_coats: 3, number_of_players: 1 } }
        end.not_to change(Event, :count)
      end
    end
  end
end
