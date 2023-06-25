# == Schema Information
#
# Table name: deposits
#
#  id           :bigint           not null, primary key
#  name_bank    :string
#  total        :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :string
#  user_id      :bigint           not null
#  file_deposit :string
#

# TODO
# buat column status yang nanti isinya create, waiting-fo-payment, expire, complete
class Deposit < ApplicationRecord
    belongs_to :user
    has_one_attached :file_deposit

    validates :status, inclusion: { in: %w(menunggu-pembayaran kadaluarsa terbayar), allow_nil: true, message: "%{value} bukan status yang benar" }
end
