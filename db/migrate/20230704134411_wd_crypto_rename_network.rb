class WdCryptoRenameNetwork < ActiveRecord::Migration[7.0]
  def change
    rename_column :withdraw_cryptos, :evm_network_id, :chain_id
  end
end
