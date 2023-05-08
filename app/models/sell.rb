# == Schema Information
#
# Table name: sells
#
#  id         :bigint           not null, primary key
#  sell       :decimal(, )
#  summary    :decimal(, )
#  date       :datetime
#  quantity   :decimal(, )
#  price      :decimal(, )
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
class Sell < ApplicationRecord
    belongs_to :user
end
