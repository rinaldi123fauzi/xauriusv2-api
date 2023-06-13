class RemoveColumnBalanceXauToBalances < ActiveRecord::Migration[7.0]
  def change
    remove_column :balances, :balance_xau
  end
end
