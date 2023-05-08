class AddColumnDateToDeposits < ActiveRecord::Migration[7.0]
  def change
    add_column :deposits, :date, :datetime
  end
end
