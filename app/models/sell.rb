# == Schema Information
#
# Table name: sells
#
#  id         :bigint           not null, primary key
#  summary    :decimal(, )
#  price      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
class Sell < ApplicationRecord
    belongs_to :user
end
