class CreateAuthAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_admins do |t|
      t.string :username
      t.string :password
      t.string :password_digest
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
