class RemoveColumnNameBankToDeposits < ActiveRecord::Migration[7.0]
  def change
    remove_column :deposits, :name_bank
  end
end
