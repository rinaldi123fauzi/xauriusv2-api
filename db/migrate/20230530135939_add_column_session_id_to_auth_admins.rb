class AddColumnSessionIdToAuthAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :auth_admins, :session_id, :integer
  end
end
