class CreateDeposits < ActiveRecord::Migration[7.0]
  def change
    create_table :deposits do |t|
      t.string :name_bank
      t.integer :unit_price
      t.integer :quantity
      t.integer :total

      t.timestamps
    end
  end
end
