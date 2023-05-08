class ChangeDatatypeQuantityIntegerToDecimalInBuys < ActiveRecord::Migration[7.0]
  def change
    change_column :buys, :quantity, :decimal
  end
end
