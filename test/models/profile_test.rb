# == Schema Information
#
# Table name: profiles
#
#  id           :bigint           not null, primary key
#  full_name    :string
#  phone_number :string
#  address      :string
#  id_number    :string
#  npwp_number  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#  status_kyc   :boolean          default(FALSE)
#  country      :string
#  file_npwp    :string
#  file_ktp     :string
#  image        :string
#
require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
