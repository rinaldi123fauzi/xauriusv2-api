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
#  status_kyc   :string           default("false")
#  country      :string
#  file_npwp    :string
#  file_ktp     :string
#  image        :string
#

# TODO: Buat status KYC
class Profile < ApplicationRecord
    belongs_to :user
    has_one_attached :file_npwp
    has_one_attached :file_ktp
    has_one_attached :image

    validates :npwp_number, uniqueness: true, allow_nil: true
    validates :id_number, uniqueness: true, allow_nil: true
    validates :status_kyc, inclusion: { in: %w(fill review rejected approved), allow_nil: true, message: "%{value} bukan status yang benar" }
end
