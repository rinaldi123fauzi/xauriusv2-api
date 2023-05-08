class AddColumnEmailVercodeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :email_vercode, :string
  end
end
