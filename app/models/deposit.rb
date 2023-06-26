# == Schema Information
#
# Table name: deposits
#
#  id           :bigint           not null, primary key
#  total        :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :string
#  user_id      :bigint           not null
#  file_deposit :string
#  bank_id      :bigint           not null
#

# TODO
# buat column status yang nanti isinya create, waiting-fo-payment, expire, complete
class Deposit < ApplicationRecord
    belongs_to :user
    belongs_to :bank, optional: true
    has_one_attached :file_deposit

    validates :status, inclusion: { in: %w(create-file file-upload kadaluarsa terbayar), allow_nil: true, message: "%{value} bukan status yang benar" }
end
