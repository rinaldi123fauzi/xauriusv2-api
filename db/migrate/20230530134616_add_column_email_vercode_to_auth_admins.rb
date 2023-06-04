class AddColumnEmailVercodeToAuthAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :auth_admins, :email_vercode, :string
  end
end
