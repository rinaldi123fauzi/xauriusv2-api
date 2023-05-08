class AddColumnOrderToDeposits < ActiveRecord::Migration[7.0]
  def change
    add_column :deposits, :order, :string
  end
end
