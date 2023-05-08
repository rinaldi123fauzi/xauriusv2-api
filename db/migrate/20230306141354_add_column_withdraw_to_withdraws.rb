class AddColumnWithdrawToWithdraws < ActiveRecord::Migration[7.0]
  def change
    add_column :withdraws, :withdraw, :integer
  end
end
