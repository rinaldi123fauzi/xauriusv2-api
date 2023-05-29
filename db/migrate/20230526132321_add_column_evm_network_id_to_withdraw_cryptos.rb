class AddColumnEvmNetworkIdToWithdrawCryptos < ActiveRecord::Migration[7.0]
  def change
    add_reference :withdraw_cryptos, :evm_network, null: false, foreign_key: true
  end
end
