class CreateInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :invites do |t|
      t.string :code, null: false
      t.references :game, null: false, foreign_key: true, unique: true
      t.string :status, :default => 'ACTIVE'
      t.references :created_by, null: false

      t.timestamps
    end

    add_foreign_key :invites, :users, column: :created_by_id, primary_key: :id
    add_column :games, :join_window, :datetime
  end
end
