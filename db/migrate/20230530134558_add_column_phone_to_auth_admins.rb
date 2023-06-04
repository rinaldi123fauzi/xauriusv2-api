class AddColumnPhoneToAuthAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :auth_admins, :phone, :string
  end
end
