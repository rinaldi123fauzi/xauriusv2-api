class AddColumnBankUserIdToWithdraws < ActiveRecord::Migration[7.0]
  def change
    add_reference :withdraws, :bank_user, null: false, foreign_key: true
  end
end
