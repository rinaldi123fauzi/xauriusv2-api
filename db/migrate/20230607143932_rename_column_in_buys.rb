class RenameColumnInBuys < ActiveRecord::Migration[7.0]
  def change
    rename_column :buys, :summary, :amount_xau
    add_column :buys, :amount_idr, :decimal
  end
end
