# == Schema Information
#
# Table name: profiles
#
#  id           :bigint           not null, primary key
#  full_name    :string
#  phone_number :string
#  address      :string
#  id_number    :integer
#  npwp_number  :string
#  deposit      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#  status       :boolean          default(FALSE)
#
require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
