class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :price, :default => "0"
      t.string :currency, :default => "INR"
      t.string :status, :default => 'FREE'

      t.timestamps
    end
  end
end
