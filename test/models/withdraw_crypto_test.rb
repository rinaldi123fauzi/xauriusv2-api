# == Schema Information
#
# Table name: withdraw_cryptos
#
#  id               :bigint           not null, primary key
#  status           :string
#  user_id          :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  to_address       :string
#  chain_id         :bigint           not null
#  currency         :string
#  amount           :decimal(, )      default(0.0)
#  amount_after_fee :decimal(, )      default(0.0)
#  txhash           :string
#  contract_address :string
#  fee              :decimal(, )      default(0.0)
#
require "test_helper"

class WithdrawCryptoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
