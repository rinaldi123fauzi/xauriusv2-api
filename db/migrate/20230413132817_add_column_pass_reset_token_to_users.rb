class AddColumnPassResetTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :pass_reset_token, :string
  end
end
