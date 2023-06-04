class CreateBlockEthAddrs < ActiveRecord::Migration[7.0]
  def change
    create_table :block_eth_addrs do |t|
      t.string :address
      t.bigint :user_id
      t.string :db_name
      t.bigint :tbl_id

      t.timestamps
    end
  end
end
