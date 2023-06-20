class SetDefaultStatusToBankUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :bank_users, :status, :boolean, default: false
  end
end
