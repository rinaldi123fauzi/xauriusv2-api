class WdCryptoAddToAddress < ActiveRecord::Migration[7.0]
  def change
    rename_column :withdraw_cryptos, :address, :to_address
  end
end
