# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  username         :string
#  password         :string
#  password_digest  :string
#  name             :string
#  email            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  session_id       :integer
#  is_email_verify  :boolean
#  is_active        :boolean
#  is_usaha         :boolean
#  name_nick        :string
#  gender           :string
#  email_vercode    :string
#  jwt_token        :string
#  pass_reset_token :string
#  phone_valid      :boolean
#  user_login_type  :string
#  role             :string
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
