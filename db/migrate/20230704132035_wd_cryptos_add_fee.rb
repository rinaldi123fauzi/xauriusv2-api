class WdCryptosAddFee < ActiveRecord::Migration[7.0]
  def change
    add_column :withdraw_cryptos, :fee, :decimal, default: 0
  end
end
