class CreateWithdraws < ActiveRecord::Migration[7.0]
  def change
    create_table :withdraws do |t|
      t.string :name_bank
      t.integer :account_number
      t.integer :cash_balance
      t.integer :ammount

      t.timestamps
    end
  end
end
