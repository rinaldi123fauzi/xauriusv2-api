# == Schema Information
#
# Table name: block_eth_addrs
#
#  id         :bigint           not null, primary key
#  address    :string
#  user_id    :bigint           default(0)
#  db_name    :string
#  tbl_id     :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BlockEthAddr < ApplicationRecord
end
