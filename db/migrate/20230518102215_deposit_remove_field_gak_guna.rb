class DepositRemoveFieldGakGuna < ActiveRecord::Migration[7.0]
  def change
    remove_column :deposits, :unit_price
    remove_column :deposits, :quantity
    remove_column :deposits, :date
    remove_column :deposits, :status
  end
end
