class CreateWithdrawCryptos < ActiveRecord::Migration[7.0]
  def change
    create_table :withdraw_cryptos do |t|
      t.string :name_bank
      t.integer :account_number
      t.string :name
      t.decimal :xau_amount
      t.string :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
