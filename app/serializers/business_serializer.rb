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
class BusinessSerializer < ActiveModel::Serializer
  attributes :id, :nama_usaha
  has_one :user
end
