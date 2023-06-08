class RenameColumnSells < ActiveRecord::Migration[7.0]
  def change
    rename_column :sells, :summary, :amount_xau
    add_column :sells, :amount_idr, :decimal
  end
end
