# == Schema Information
#
# Table name: banks
#
#  id         :bigint           not null, primary key
#  name_bank  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Bank < ApplicationRecord
    has_many :withdraw
    validates :name_bank, uniqueness: true
end
