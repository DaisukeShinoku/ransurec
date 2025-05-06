class DropProducts < ActiveRecord::Migration[8.0]
  def change
    drop_table :products do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
