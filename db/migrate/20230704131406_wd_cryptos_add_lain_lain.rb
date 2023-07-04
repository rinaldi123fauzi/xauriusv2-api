class WdCryptosAddLainLain < ActiveRecord::Migration[7.0]
  def change
    add_column :withdraw_cryptos, :currency, :string
    add_column :withdraw_cryptos, :amount, :decimal, default: 0
    add_column :withdraw_cryptos, :amount_after_fee, :decimal, default: 0
    add_column :withdraw_cryptos, :txid, :string 
    add_column :withdraw_cryptos, :contract_address, :string 
    remove_column :withdraw_cryptos, :xau_amount
  end
end
