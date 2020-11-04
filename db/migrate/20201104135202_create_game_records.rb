class CreateGameRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :game_records, id: false do |t|
      t.references :game, null: false, foreign_key: true, unique: true
      t.string :player1
      t.string :player2
      t.string :player3
      t.string :player4
      t.boolean :save, :default => false

      t.timestamps
    end
  end
end
