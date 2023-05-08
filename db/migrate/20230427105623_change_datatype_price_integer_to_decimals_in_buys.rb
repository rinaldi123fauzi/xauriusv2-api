class ChangeDatatypePriceIntegerToDecimalsInBuys < ActiveRecord::Migration[7.0]
  def change
    change_column :buys, :price, :decimal
  end
end
