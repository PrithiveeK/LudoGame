class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :room, null: false
      t.references :player1, null: false
      t.references :player2, null: false
      t.references :player3
      t.references :player4
      t.datetime :scheduled_at
      t.string :status, :default => 'ACTIVE'

      t.timestamps
    end

    add_foreign_key :games, :users, column: :player1_id, primary_key: :id
    add_foreign_key :games, :users, column: :player2_id, primary_key: :id
    add_foreign_key :games, :users, column: :player3_id, primary_key: :id
    add_foreign_key :games, :users, column: :player4_id, primary_key: :id
  end
end
