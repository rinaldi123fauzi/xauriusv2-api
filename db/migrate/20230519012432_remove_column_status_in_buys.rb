class RemoveColumnStatusInBuys < ActiveRecord::Migration[7.0]
  def change
    remove_column :buys, :status
  end
end
