# == Schema Information
#
# Table name: withdraws
#
#  id             :bigint           not null, primary key
#  name_bank      :string
#  account_number :integer
#  ammount        :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  status         :string
#  user_id        :bigint           not null
#  name           :string
#
class Withdraw < ApplicationRecord
    belongs_to :user

    validates :status, inclusion: { in: %w(sedang-diproses selesai), allow_nil: true, message: "%{value} bukan status yang benar" }
end
