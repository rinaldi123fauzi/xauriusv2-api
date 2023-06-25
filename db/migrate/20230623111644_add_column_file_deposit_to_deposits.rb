class AddColumnFileDepositToDeposits < ActiveRecord::Migration[7.0]
  def change
    add_column :deposits, :file_deposit, :string
  end
end
