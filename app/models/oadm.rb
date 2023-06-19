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
class Oadm < ApplicationRecord
  include BCrypt

  acts_as_google_authenticated :method => :user_name_with_label
  # disini kita memberi nama google auth
  # misalnya, user mempunya email nitzaalfinas@gmail.com
  # disini akan menjadi nitzaalfinas-adm@incrypto.co.id
  def user_name_with_label
    "#{oadm_email.split("@").first.downcase}-adm@#{ENV["TWOFA_DOMAIN"]}"
  end

  def valid_password?(password)
    BCrypt::Password.new(oadm_password) == password.to_s
  end

  def two_factor_is_active?
    two_factor_is_active.eql? true
  end

  def update_two_factor!
    update!(two_factor_is_active: true)
  end

  def reset_google_auth
    update!(google_secret: nil, two_factor_is_active: false)
  end
end
