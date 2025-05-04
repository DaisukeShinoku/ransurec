require "rails_helper"

RSpec.describe "events", type: :system do
  describe "GET /" do
    context "初期値から何も変更せずに登録する場合" do
      it "乱数表が作成されること" do
        visit "/"

        expect do
          click_on "乱数表を"

          expect(page).to have_text(/\d{4}年\d{2}月\d{2}日\d{2}時\d{2}分/)
        end.to change(Event, :count).by(1)
      end
    end

    context "初期値から別の有効な値に変更して登録する場合" do
      it "乱数表が作成されること" do
        visit "/"

        expect do
          fill_in "イベント名", with: "hoge練習会"
          choose "シングルス"
          choose "2面"
          fill_in "選手数", with: "13"

          click_on "乱数表を作成"

          expect(page).to have_text("hoge練習会")
        end.to change(Event, :count).by(1)
      end
    end

    context "初期値から無効な値に変更して登録する場合" do
      it "乱数表が作成されないこと" do
        visit "/"

        expect do
          fill_in "イベント名", with: ""
          choose "ダブルス"
          choose "2面"
          fill_in "選手数", with: "2"

          click_on "乱数表を作成"

          expect(page).to have_text("イベントの登録に失敗しました。")
        end.not_to change(Event, :count)
      end
    end
  end
end
