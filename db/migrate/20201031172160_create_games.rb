class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :room, null: false
      t.string :code, null: false
      t.datetime :scheduled_at
      t.datetime :join_window
      t.boolean :is_saved, :default => false
      t.string :status, :default => 'ACTIVE'
      t.references :created_by, null: false

      t.timestamps
    end
    
    add_foreign_key :games, :users, column: :created_by_id, primary_key: :id
  end
end
