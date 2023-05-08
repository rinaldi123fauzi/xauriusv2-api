class AddColumnNameNickToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name_nick, :string
  end
end
