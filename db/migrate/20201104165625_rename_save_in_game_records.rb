class RenameSaveInGameRecords < ActiveRecord::Migration[6.0]
  def change
    rename_column :game_records, :save, :is_saved
  end
end
