class CreateGameRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :game_records do |t|
      t.references :game, null: false, foreign_key: true, unique: true
      t.references :player, null: false
      t.string :place
      t.boolean :has_joined, :default => false

      t.timestamps
    end
    add_foreign_key :game_records, :users, column: :player_id, primary_key: :id
  end
end
