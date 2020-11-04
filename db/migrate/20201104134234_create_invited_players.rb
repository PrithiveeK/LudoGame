class CreateInvitedPlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :invited_players do |t|
      t.references :invite, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :claimed, :default => false

      t.timestamps
    end
  end
end
