class ChangeDatatypeSellIntegerToDecimalsInSells < ActiveRecord::Migration[7.0]
  def change
    change_column :sells, :sell, :decimal
  end
end
