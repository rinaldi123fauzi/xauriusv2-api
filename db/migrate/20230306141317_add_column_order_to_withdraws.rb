class AddColumnOrderToWithdraws < ActiveRecord::Migration[7.0]
  def change
    add_column :withdraws, :order, :string
  end
end
