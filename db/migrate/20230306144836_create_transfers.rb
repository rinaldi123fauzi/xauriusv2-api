class CreateTransfers < ActiveRecord::Migration[7.0]
  def change
    create_table :transfers do |t|
      t.string :network
      t.string :address_wallet
      t.datetime :date
      t.string :tx_hash
      t.string :address
      t.integer :quantity
      t.integer :status

      t.timestamps
    end
  end
end
