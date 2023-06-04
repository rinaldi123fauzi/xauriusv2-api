class BlockEthAddrDefaultUserId < ActiveRecord::Migration[7.0]
  def change
    change_column :block_eth_addrs, :user_id, :bigint, default: 0
  end
end
