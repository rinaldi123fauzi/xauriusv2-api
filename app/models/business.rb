# == Schema Information
#
# Table name: businesses
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  nama_usaha :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Business < ApplicationRecord
  belongs_to :user
end
