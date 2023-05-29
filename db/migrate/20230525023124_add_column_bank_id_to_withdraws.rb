class AddColumnBankIdToWithdraws < ActiveRecord::Migration[7.0]
  def change
    add_reference :withdraws, :bank, null: false, foreign_key: true
  end
end
