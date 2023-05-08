class AddColumnStatusToWithdraws < ActiveRecord::Migration[7.0]
  def change
    add_column :withdraws, :status, :integer
  end
end
