# == Schema Information
#
# Table name: histories
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  table      :string
#  table_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class HistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
