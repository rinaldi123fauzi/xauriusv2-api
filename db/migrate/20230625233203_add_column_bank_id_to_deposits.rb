class AddColumnBankIdToDeposits < ActiveRecord::Migration[7.0]
  def change
    add_reference :deposits, :bank, null: false, foreign_key: true
  end
end
