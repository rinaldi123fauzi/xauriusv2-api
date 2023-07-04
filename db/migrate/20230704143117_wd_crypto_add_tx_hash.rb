class WdCryptoAddTxHash < ActiveRecord::Migration[7.0]
  def change
    rename_column :withdraw_cryptos, :txid, :txhash 
  end
end
