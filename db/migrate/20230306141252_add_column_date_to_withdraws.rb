class AddColumnDateToWithdraws < ActiveRecord::Migration[7.0]
  def change
    add_column :withdraws, :date, :datetime
  end
end
