class RemoveColumnInWithdraw < ActiveRecord::Migration[7.0]
  def change
    remove_column :withdraws, :date
    remove_column :withdraws, :withdraw
    remove_column :withdraws, :cash_balance
    remove_column :withdraws, :order
  end
end
