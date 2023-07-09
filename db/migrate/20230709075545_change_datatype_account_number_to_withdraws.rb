class ChangeDatatypeAccountNumberToWithdraws < ActiveRecord::Migration[7.0]
  def change
    change_column :withdraws, :account_number, :string
  end
end
