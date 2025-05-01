require "rails_helper"

RSpec.describe Event, type: :model do
  describe "#player_standings" do
    it "TODO: シングルス・ダブルスそれぞれで1パターンずつテストを追加する"
  end

  describe "#matches_grouped_by_sequence" do
    let(:event) { create(:event) }

    context "複数の試合順を持つマッチが存在する場合" do
      before do
        create(:match, event: event, sequence_num: 1, coat_num: 1)
        create(:match, event: event, sequence_num: 1, coat_num: 2)

        create(:match, event: event, sequence_num: 2, coat_num: 1)
        create(:match, event: event, sequence_num: 2, coat_num: 2)

        create(:match, event: event, sequence_num: 3, coat_num: 1)
      end

      it "試合順でグループ化されたマッチのハッシュを返すこと" do
        result = event.matches_grouped_by_sequence

        expect(result).to be_a(Hash)

        expect(result.keys).to contain_exactly(1, 2, 3)
        expect(result[1].size).to eq(2)
        expect(result[2].size).to eq(2)
        expect(result[3].size).to eq(1)
      end

      it "コート番号でソートされていること" do
        result = event.matches_grouped_by_sequence

        expect(result[1].map(&:coat_num)).to eq([1, 2])

        expect(result[2].map(&:coat_num)).to eq([1, 2])
      end
    end

    context "試合が存在しない場合" do
      it "空のハッシュを返すこと" do
        result = event.matches_grouped_by_sequence
        expect(result).to be_empty
      end
    end
  end
end
