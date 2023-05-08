class ChangeDatatypeCashBalanceIntegerToDecimalsInWithdraws < ActiveRecord::Migration[7.0]
  def change
    change_column :withdraws, :cash_balance, :decimal
  end
end
