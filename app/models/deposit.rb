# == Schema Information
#
# Table name: deposits
#
#  id         :bigint           not null, primary key
#  name_bank  :string
#  unit_price :decimal(, )
#  quantity   :decimal(, )
#  total      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  date       :datetime
#  order      :string
#  user_id    :bigint           not null
#
class Deposit < ApplicationRecord
    belongs_to :user
end
