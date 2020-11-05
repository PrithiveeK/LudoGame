class AddDefaultPieceToUserRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :user_records, :default_piece_id, :integer, null: false, foreign_key: true, default: 1
  end
end
