# == Schema Information
#
# Table name: withdraw_cryptos
#
#  id         :bigint           not null, primary key
#  xau_amount :decimal(, )
#  status     :string
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  address    :string
#  network    :string
#
class WithdrawCrypto < ApplicationRecord
  belongs_to :user

  validates :status, inclusion: { in: %w(buat tidak-terkirim selesai), allow_nil: true, message: "%{value} bukan status yang benar" }
end
