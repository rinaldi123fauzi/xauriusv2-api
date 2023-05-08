class ChangeDatatypeQuantityIntegerToDecimalInDeposits < ActiveRecord::Migration[7.0]
  def change
    change_column :deposits, :quantity, :decimal
  end
end
