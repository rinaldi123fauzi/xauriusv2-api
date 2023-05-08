class ChangeDatatypeQuantityIntegerToDecimalInTransfers < ActiveRecord::Migration[7.0]
  def change
    change_column :transfers, :quantity, :decimal
  end
end
