require "rails_helper"

RSpec.describe Event, type: :model do
  describe "#matches_grouped_by_sequence" do
    let(:event) { create(:event) }

    context "複数のシーケンス番号を持つマッチが存在する場合" do
      before do
        # シーケンス番号1のマッチを2つ作成
        create(:match, event: event, sequence_num: 1, coat_num: 1)
        create(:match, event: event, sequence_num: 1, coat_num: 2)

        # シーケンス番号2のマッチを2つ作成
        create(:match, event: event, sequence_num: 2, coat_num: 1)
        create(:match, event: event, sequence_num: 2, coat_num: 2)

        # シーケンス番号3のマッチを1つ作成
        create(:match, event: event, sequence_num: 3, coat_num: 1)
      end

      it "シーケンス番号でグループ化されたマッチのハッシュを返すこと" do
        result = event.matches_grouped_by_sequence

        # 結果がハッシュであることを確認
        expect(result).to be_a(Hash)

        # 3つのシーケンス番号のグループが存在することを確認
        expect(result.keys).to contain_exactly(1, 2, 3)

        # シーケンス番号1のグループに2つのマッチが含まれることを確認
        expect(result[1].size).to eq(2)

        # シーケンス番号2のグループに2つのマッチが含まれることを確認
        expect(result[2].size).to eq(2)

        # シーケンス番号3のグループに1つのマッチが含まれることを確認
        expect(result[3].size).to eq(1)
      end

      it "コート番号でソートされていること" do
        result = event.matches_grouped_by_sequence

        # シーケンス番号1のグループ内でコート番号順にソートされていることを確認
        expect(result[1].map(&:coat_num)).to eq([1, 2])

        # シーケンス番号2のグループ内でコート番号順にソートされていることを確認
        expect(result[2].map(&:coat_num)).to eq([1, 2])
      end
    end

    context "マッチが存在しない場合" do
      it "空のハッシュを返すこと" do
        result = event.matches_grouped_by_sequence
        expect(result).to be_empty
      end
    end
  end
end
