# == Schema Information
#
# Table name: deposits
#
#  id           :bigint           not null, primary key
#  total        :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :string
#  user_id      :bigint           not null
#  file_deposit :string
#  bank_id      :bigint
#  description  :string
#
require "test_helper"

class DepositTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
