class AddColumnIsActiveToAuthAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :auth_admins, :is_active, :boolean
  end
end
