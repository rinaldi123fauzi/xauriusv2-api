class ChangeDatatypeWithdrawIntegerToDecimalsInWithdraws < ActiveRecord::Migration[7.0]
  def change
    change_column :withdraws, :withdraw, :decimal
  end
end
