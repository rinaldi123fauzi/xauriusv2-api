class ChangeDatatypePriceIntegerToDecimalsInSells < ActiveRecord::Migration[7.0]
  def change
    change_column :sells, :price, :decimal
  end
end
