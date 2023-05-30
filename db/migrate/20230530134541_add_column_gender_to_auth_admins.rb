class AddColumnGenderToAuthAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :auth_admins, :gender, :string
  end
end
