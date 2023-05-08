class ChangeDatatypeSummaryIntegerToDecimalsInSells < ActiveRecord::Migration[7.0]
  def change
    change_column :sells, :summary, :decimal
  end
end
