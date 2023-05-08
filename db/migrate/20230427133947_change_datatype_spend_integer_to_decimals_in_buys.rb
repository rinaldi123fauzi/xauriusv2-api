class ChangeDatatypeSpendIntegerToDecimalsInBuys < ActiveRecord::Migration[7.0]
  def change
    change_column :buys, :spend, :decimal
  end
end
