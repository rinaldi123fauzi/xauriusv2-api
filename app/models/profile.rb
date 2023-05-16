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
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#  status_kyc   :boolean          default(FALSE)
#  country      :string
#  file_npwp    :string
#  file_ktp     :string
#  image        :string
#

class Profile < ApplicationRecord
    belongs_to :user
    has_one_attached :file_npwp
    has_one_attached :file_ktp
    has_one_attached :image

    validates :id_number, uniqueness: true
    validates :npwp_number, uniqueness: true
end
