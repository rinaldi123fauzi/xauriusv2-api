class ChangeDatatypeAmmountIntegerToDecimalsInWithdraws < ActiveRecord::Migration[7.0]
  def change
    change_column :withdraws, :ammount, :decimal
  end
end
