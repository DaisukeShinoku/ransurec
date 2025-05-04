require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  # rubocop:disable RSpec/VerifiedDoubles, RSpec/ReceiveMessages
  describe "#display_event_name" do
    context "イベントが有効な場合" do
      it "保存済みイベントの名前を返すこと" do
        event = double("Event", id: 1, name: "テスト大会")
        allow(event).to receive(:present?).and_return(true)
        allow(event).to receive(:respond_to?).with(:id).and_return(true)
        expect(helper.display_event_name(event)).to eq("テスト大会")
      end
    end

    context "イベントが無効な場合" do
      it "nilの場合はデフォルトテキストを返すこと" do
        expect(helper.display_event_name(nil)).to eq("テニスの乱数表")
      end

      it "空のイベントの場合はデフォルトテキストを返すこと" do
        event = double("Event")
        allow(event).to receive(:present?).and_return(true)
        allow(event).to receive(:respond_to?).with(:id).and_return(true)
        allow(event).to receive(:id).and_return(nil)
        expect(helper.display_event_name(event)).to eq("テニスの乱数表")
      end

      it "idメソッドがないイベントの場合はデフォルトテキストを返すこと" do
        event = double("Event::Launch")
        allow(event).to receive(:present?).and_return(true)
        allow(event).to receive(:respond_to?).with(any_args).and_return(true)
        allow(event).to receive(:respond_to?).with(:id).and_return(false)
        expect(helper.display_event_name(event)).to eq("テニスの乱数表")
      end
    end
  end
  # rubocop:enable RSpec/VerifiedDoubles, RSpec/ReceiveMessages
end
