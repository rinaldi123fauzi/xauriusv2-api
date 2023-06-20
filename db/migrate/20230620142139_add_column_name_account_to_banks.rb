class AddColumnNameAccountToBanks < ActiveRecord::Migration[7.0]
  def change
    add_column :banks, :name_account, :string
  end
end
