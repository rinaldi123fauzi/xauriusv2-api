class ChangeDatatypeSummaryIntegerToDecimalsInBuys < ActiveRecord::Migration[7.0]
  def change
    change_column :buys, :summary, :decimal
  end
end
