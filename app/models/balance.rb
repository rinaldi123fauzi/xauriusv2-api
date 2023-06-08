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
#  balance_xau   :decimal(, )      default(0.0)
#

# TODO: hapus balance_xau
class Balance < ApplicationRecord
  belongs_to :user

  validates :currency, inclusion: { in: %w(XAU IDR), allow_nil: true, message: "%{value} bukan currency yang benar" }
end

# ID user_id  currency balance_value
# 1  1        XAU      12
# 2  1        IDR      8000000
# 3  2        XAU      10
# 4  2        IDR      7000000