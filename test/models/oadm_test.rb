# == Schema Information
#
# Table name: oadms
#
#  id                        :bigint           not null, primary key
#  oadm_email                :string
#  oadm_name                 :string
#  oadm_password             :string
#  oadm_passchange_token     :integer
#  oadm_photo                :string
#  oadm_status               :string
#  google_secret             :string
#  reset_google_secret_token :string
#  two_factor_is_active      :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
require "test_helper"

class OadmTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
