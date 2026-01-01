class CreatePlayers < ActiveRecord::Migration[8.1]
  def change
    create_table :players, comment: "選手" do |t|
      t.references :meetup, null: false, foreign_key: true, comment: "ミートアップ"
      t.string :display_name, null: false, comment: "表示名"
      t.timestamps
    end
  end
end
