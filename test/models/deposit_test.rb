# == Schema Information
#
# Table name: deposits
#
#  id         :bigint           not null, primary key
#  name_bank  :string
#  total      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :string
#  user_id    :bigint           not null
#
require "test_helper"

class DepositTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
