class CreateCcdeposits < ActiveRecord::Migration[7.0]
  def change
    create_table :ccdeposits do |t|
      t.bigint :user_id
      t.decimal :ccdeposit_amount
      t.bigint :ccdeposit_confirmation_count
      t.text :ccdeposit_data
      t.string :ccdeposit_status
      t.string :ccdeposit_txhash
      t.string :ccurrency_symbol
      t.bigint :evm_chain_id

      t.timestamps
    end
  end
end
