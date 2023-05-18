# == Schema Information
#
# Table name: buys
#
#  id         :bigint           not null, primary key
#  summary    :decimal(, )
#  price      :decimal(, )
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
class Buy < ApplicationRecord
    belongs_to :user
end
