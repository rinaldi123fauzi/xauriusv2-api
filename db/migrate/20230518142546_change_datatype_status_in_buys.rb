class ChangeDatatypeStatusInBuys < ActiveRecord::Migration[7.0]
  def change
    change_column :buys, :status, :string
  end
end
