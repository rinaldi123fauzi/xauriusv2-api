# == Schema Information
#
# Table name: withdraws
#
#  id             :bigint           not null, primary key
#  name_bank      :string
#  account_number :integer
#  cash_balance   :decimal(, )
#  ammount        :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  date           :datetime
#  order          :string
#  withdraw       :decimal(, )
#  status         :integer
#  user_id        :bigint           not null
#
class Withdraw < ApplicationRecord
    belongs_to :user
end
