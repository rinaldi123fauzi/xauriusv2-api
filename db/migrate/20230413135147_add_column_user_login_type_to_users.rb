class AddColumnUserLoginTypeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_login_type, :string
  end
end
