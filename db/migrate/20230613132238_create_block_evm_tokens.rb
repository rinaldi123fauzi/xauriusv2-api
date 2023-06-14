class CreateBlockEvmTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :block_evm_tokens do |t|
      t.bigint :chain_id
      t.string :contract_address
      t.integer :contract_decimals
      t.boolean :tracking
      t.string :token_name
      t.string :token_symbol
      t.bigint :currency_id
      t.decimal :wd_fee

      t.timestamps
    end
  end
end
