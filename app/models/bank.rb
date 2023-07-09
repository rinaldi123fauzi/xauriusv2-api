# == Schema Information
#
# Table name: banks
#
#  id              :bigint           not null, primary key
#  name_bank       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name_account    :string
#  number_rekening :string
#
class Bank < ApplicationRecord
    validates :name_bank, uniqueness: true, presence: true
    validates :name_account, presence: true
    validates :number_rekening, uniqueness: true, presence: true
    has_many :deposit
end
