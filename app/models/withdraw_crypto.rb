# == Schema Information
#
# Table name: withdraw_cryptos
#
#  id             :bigint           not null, primary key
#  xau_amount     :decimal(, )
#  status         :string
#  user_id        :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  address        :string
#  evm_network_id :bigint           not null
#
class WithdrawCrypto < ApplicationRecord

  after_save :save_to_history

  belongs_to :user
  belongs_to :evm_network
  validates :status, inclusion: { in: %w(buat tidak-terkirim selesai), allow_nil: true, message: "%{value} bukan status yang benar" }

  private 

  def save_to_history 
    # cek di history, apakah sudah ada datanya
    thedata = History.where(user_id: self.user_id, table: 'withdraw_cryptos', table_id: self.id)
    if thedata.count == 0
      History.create({
        user_id: self.user_id, 
        table: 'withdraw_cryptos', 
        table_id: self.id
      })
    end
  end
end
