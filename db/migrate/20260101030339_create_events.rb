class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events, comment: "イベント" do |t|
      t.string :name, null: false, comment: "イベント名"
      t.integer :match_format, null: false, default: 1, comment: "試合形式"
      t.integer :number_of_coats, null: false, default: 1, comment: "コート数"
      t.timestamps
    end
  end
end
