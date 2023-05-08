class ChangeDatatypeUnitPriceIntegerToDecimalsInDeposits < ActiveRecord::Migration[7.0]
  def change
    change_column :deposits, :unit_price, :decimal
  end
end
