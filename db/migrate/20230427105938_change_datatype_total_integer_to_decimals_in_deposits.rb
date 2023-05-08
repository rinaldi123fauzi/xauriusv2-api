class ChangeDatatypeTotalIntegerToDecimalsInDeposits < ActiveRecord::Migration[7.0]
  def change
    change_column :deposits, :total, :decimal
  end
end
