class AddColumnStatusToDeposits < ActiveRecord::Migration[7.0]
  def change
    add_column :deposits, :status, :string
  end
end
