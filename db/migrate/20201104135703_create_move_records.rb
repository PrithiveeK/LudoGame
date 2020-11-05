class CreateMoveRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :move_records do |t|
      t.references :game_record, null: false, foreign_key: true
      t.string :player
      t.string :piece
      t.integer :last_position

      t.timestamps
    end
  end
end
