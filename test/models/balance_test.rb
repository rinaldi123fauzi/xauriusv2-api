# == Schema Information
#
# Table name: balances
#
#  id            :bigint           not null, primary key
#  user_id       :bigint           not null
#  balance_value :decimal(, )
#  currency      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "test_helper"

class BalanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
