# == Schema Information
#
# Table name: block_eth_addrs
#
#  id         :bigint           not null, primary key
#  address    :string
#  user_id    :bigint
#  db_name    :string
#  tbl_id     :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class BlockEthAddrTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
