class RemoveColumnNameBankToWithdraws < ActiveRecord::Migration[7.0]
  def change
    remove_column :withdraws, :name_bank
  end
end
