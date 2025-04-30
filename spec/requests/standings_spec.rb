require "rails_helper"

RSpec.describe "Standings", type: :request do
  describe "standings#show" do
    let(:event) { create(:event) }

    it "乱数表の詳細画面が表示されること" do
      get event_standings_path(event)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(event.name)
    end
  end
end
