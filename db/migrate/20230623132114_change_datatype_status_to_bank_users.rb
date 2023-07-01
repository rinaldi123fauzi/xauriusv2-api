class ChangeDatatypeStatusToBankUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :bank_users, :status, :string, default: 'unlock'
  end
end
