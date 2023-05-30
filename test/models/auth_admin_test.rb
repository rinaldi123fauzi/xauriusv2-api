# == Schema Information
#
# Table name: auth_admins
#
#  id               :bigint           not null, primary key
#  username         :string
#  password         :string
#  password_digest  :string
#  name             :string
#  email            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  is_active        :boolean
#  gender           :string
#  phone            :string
#  email_vercode    :string
#  is_email_verify  :boolean
#  pass_reset_token :integer
#  session_id       :integer
#  jwt_token        :string
#
require "test_helper"

class AuthAdminTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
