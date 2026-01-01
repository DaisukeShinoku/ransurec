class CreateMatchPlayers < ActiveRecord::Migration[8.1]
  def change
    create_table :match_players, comment: "試合_選手" do |t|
      t.references :match, null: false, foreign_key: true, comment: "試合"
      t.references :player, null: false, foreign_key: true, comment: "選手"
      t.integer :side, null: false, default: 1, comment: "サイド"
      t.timestamps
    end
  end
end
