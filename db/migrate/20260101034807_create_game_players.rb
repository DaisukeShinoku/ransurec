class CreateGamePlayers < ActiveRecord::Migration[8.1]
  def change
    create_table :game_players, comment: "試合_選手" do |t|
      t.references :game, null: false, foreign_key: true, comment: "試合"
      t.references :player, null: false, foreign_key: true, comment: "選手"
      t.integer :side, null: false, default: 1, comment: "サイド"
      t.timestamps
    end
  end
end
