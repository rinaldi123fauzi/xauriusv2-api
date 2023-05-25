class RemoveColumnNameToWithdrawCryptos < ActiveRecord::Migration[7.0]
  def change
    remove_column :withdraw_cryptos, :name
  end
end
