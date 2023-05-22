class AddColumnNameToWithdraws < ActiveRecord::Migration[7.0]
  def change
    add_column :withdraws, :name, :string
  end
end
