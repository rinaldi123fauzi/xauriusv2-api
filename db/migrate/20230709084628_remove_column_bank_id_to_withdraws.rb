class RemoveColumnBankIdToWithdraws < ActiveRecord::Migration[7.0]
  def change
    remove_column :withdraws, :bank_id
  end
end
