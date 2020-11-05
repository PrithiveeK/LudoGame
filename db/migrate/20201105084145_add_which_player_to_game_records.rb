class AddWhichPlayerToGameRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :game_records, :which_player, :string
  end
end
