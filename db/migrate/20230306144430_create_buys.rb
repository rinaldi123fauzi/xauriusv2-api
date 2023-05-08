class CreateBuys < ActiveRecord::Migration[7.0]
  def change
    create_table :buys do |t|
      t.integer :spend
      t.integer :summary
      t.datetime :date
      t.integer :price
      t.integer :quantity
      t.integer :status

      t.timestamps
    end
  end
end
