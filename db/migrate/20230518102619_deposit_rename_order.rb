class DepositRenameOrder < ActiveRecord::Migration[7.0]
  def change
    rename_column :deposits, :order, :status
  end
end
