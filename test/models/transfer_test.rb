# == Schema Information
#
# Table name: transfers
#
#  id             :bigint           not null, primary key
#  network        :string
#  address_wallet :string
#  date           :datetime
#  tx_hash        :string
#  address        :string
#  quantity       :decimal(, )
#  status         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
require "test_helper"

class TransferTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
