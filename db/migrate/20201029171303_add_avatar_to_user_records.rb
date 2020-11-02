class AddAvatarToUserRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :user_records, :avatar, :string
  end
end
