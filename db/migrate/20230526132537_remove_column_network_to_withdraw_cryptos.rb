class RemoveColumnNetworkToWithdrawCryptos < ActiveRecord::Migration[7.0]
  def change
    remove_column :withdraw_cryptos, :network
  end
end
