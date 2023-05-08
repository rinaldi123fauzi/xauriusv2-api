class AddColumnIsUsahaToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_usaha, :boolean
  end
end
