class AddColumnIsEmailVerifyToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_email_verify, :boolean
  end
end
