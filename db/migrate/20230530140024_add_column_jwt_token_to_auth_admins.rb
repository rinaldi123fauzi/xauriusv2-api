class AddColumnJwtTokenToAuthAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :auth_admins, :jwt_token, :string
  end
end
