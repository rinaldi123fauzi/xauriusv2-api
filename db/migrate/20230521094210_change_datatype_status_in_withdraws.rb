class ChangeDatatypeStatusInWithdraws < ActiveRecord::Migration[7.0]
  def change
    change_column :withdraws, :status, :string
  end
end
