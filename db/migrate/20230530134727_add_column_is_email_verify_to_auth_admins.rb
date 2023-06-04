class AddColumnIsEmailVerifyToAuthAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :auth_admins, :is_email_verify, :boolean
  end
end
