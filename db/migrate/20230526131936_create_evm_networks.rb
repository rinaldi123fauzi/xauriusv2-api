class CreateEvmNetworks < ActiveRecord::Migration[7.0]
  def change
    create_table :evm_networks do |t|
      t.string :network_name
      t.string :rpc_url
      t.integer :chain_id
      t.string :currency_symbol
      t.text :explorer

      t.timestamps
    end
  end
end
