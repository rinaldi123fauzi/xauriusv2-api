class AddColumnBalanceXauToBalances < ActiveRecord::Migration[7.0]
  def change
    add_column :balances, :balance_xau, :decimal, default: 0
  end
end
