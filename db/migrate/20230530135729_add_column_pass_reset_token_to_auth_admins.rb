class AddColumnPassResetTokenToAuthAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :auth_admins, :pass_reset_token, :integer
  end
end
