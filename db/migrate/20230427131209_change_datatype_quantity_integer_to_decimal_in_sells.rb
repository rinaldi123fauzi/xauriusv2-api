class ChangeDatatypeQuantityIntegerToDecimalInSells < ActiveRecord::Migration[7.0]
  def change
    change_column :sells, :quantity, :decimal
  end
end
