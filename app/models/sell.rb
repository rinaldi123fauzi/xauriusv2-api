# == Schema Information
#
# Table name: sells
#
#  id         :bigint           not null, primary key
#  amount_xau :decimal(, )
#  price      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#  amount_idr :decimal(, )
#
class Sell < ApplicationRecord
    belongs_to :user
end
