class AddColumnSessionIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :session_id, :integer
  end
end
