class CreateUserRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :user_records, id: false do |t|
      t.references :user, null: false, foreign_key: true, primary_key: true
      t.boolean :is_online, default: false
      t.boolean :in_game, default: false
      t.integer :number_of_games, default: 0
      t.integer :points, default: 0
      t.integer :level, default: 1      

      t.timestamps
    end
  end
end
