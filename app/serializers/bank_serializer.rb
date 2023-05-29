# == Schema Information
#
# Table name: banks
#
#  id         :bigint           not null, primary key
#  name_bank  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BankSerializer < ActiveModel::Serializer
  attributes :id, :name_bank
end
