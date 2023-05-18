# == Schema Information
#
# Table name: balances
#
#  id            :bigint           not null, primary key
#  user_id       :bigint           not null
#  balance_value :decimal(, )
#  currency      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Balance < ApplicationRecord
  belongs_to :user

  validates :currency, inclusion: { in: %w(XAU IDR), allow_nil: true, message: "%{value} bukan currency yang benar" }
end
