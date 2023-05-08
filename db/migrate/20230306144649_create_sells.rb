class CreateSells < ActiveRecord::Migration[7.0]
  def change
    create_table :sells do |t|
      t.integer :sell
      t.integer :summary
      t.datetime :date
      t.integer :quantity
      t.integer :price
      t.integer :status

      t.timestamps
    end
  end
end
