# == Schema Information
#
# Table name: withdraw_cryptos
#
#  id         :bigint           not null, primary key
#  name       :string
#  xau_amount :decimal(, )
#  status     :string
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class WithdrawCryptoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
