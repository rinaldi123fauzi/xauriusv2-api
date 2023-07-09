# == Schema Information
#
# Table name: withdraws
#
#  id             :bigint           not null, primary key
#  account_number :string
#  ammount        :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  status         :string
#  user_id        :bigint           not null
#  name           :string
#  bank_user_id   :bigint           not null
#
require "test_helper"

class WithdrawTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
