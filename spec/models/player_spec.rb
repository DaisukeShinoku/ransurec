require "rails_helper"

RSpec.describe Player, type: :model do
  describe ".insert_all_default_players" do
    let(:event) { create(:event) }
    let(:number_of_players) { 5 }

    it "イベントに紐付いて「選手n」という名前で選手が作成されること" do
      described_class.insert_all_default_players(event: event, number_of_players: number_of_players)
      players = described_class.where(event: event)

      expect(players.count).to eq(number_of_players)
      players.each_with_index do |player, index|
        expect(player.display_name).to eq("選手#{index + 1}")
        expect(player.event_id).to eq(event.id)
      end
    end
  end
end
