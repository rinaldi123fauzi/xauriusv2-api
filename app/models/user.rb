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
#
class User < ApplicationRecord
    has_secure_password
    has_many :deposit, dependent: :destroy
    has_many :withdraw, dependent: :destroy
    has_many :transfer, dependent: :destroy
    has_many :profile, dependent: :destroy
    has_one :balance, dependent: :destroy
    has_many :buy, dependent: :destroy
    has_many :sell, dependent: :destroy
    has_many :withdraw_crypto, dependent: :destroy
    has_many :bank_user, dependent: :destroy

    validates :email, uniqueness: true
end
