# == Schema Information
#
# Table name: buys
#
#  id         :bigint           not null, primary key
#  spend      :decimal(, )
#  summary    :decimal(, )
#  date       :datetime
#  price      :decimal(, )
#  quantity   :decimal(, )
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
require "test_helper"

class BuyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
