class CreateMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :matches, comment: "試合" do |t|
      t.references :event, null: false, foreign_key: true, comment: "イベント"
      t.integer :coat_num, null: false, default: 1, comment: "実施コート"
      t.integer :sequence_num, null: false, default: 1, comment: "試合順"
      t.integer :match_format, null: false, default: 1, comment: "試合形式"
      t.integer :home_score, null: false, default: 0, comment: "ホーム側のスコア"
      t.integer :away_score, null: false, default: 0, comment: "アウェイ側のスコア"
      t.timestamps
    end
  end
end
