class RemoveColumnBuys < ActiveRecord::Migration[7.0]
  def change
    remove_column :buys, :spend
    remove_column :buys, :date
    remove_column :buys, :quantity
  end
end
