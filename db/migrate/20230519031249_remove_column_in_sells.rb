class RemoveColumnInSells < ActiveRecord::Migration[7.0]
  def change
    remove_column :sells, :status
    remove_column :sells, :sell
    remove_column :sells, :quantity
    remove_column :sells, :date
  end
end
