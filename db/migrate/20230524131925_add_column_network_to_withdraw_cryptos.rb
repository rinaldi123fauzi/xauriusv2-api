class AddColumnNetworkToWithdrawCryptos < ActiveRecord::Migration[7.0]
  def change
    add_column :withdraw_cryptos, :network, :string
  end
end
