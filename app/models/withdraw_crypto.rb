# == Schema Information
#
# Table name: withdraw_cryptos
#
#  id               :bigint           not null, primary key
#  status           :string
#  user_id          :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  to_address       :string
#  chain_id         :bigint           not null
#  currency         :string
#  amount           :decimal(, )      default(0.0)
#  amount_after_fee :decimal(, )      default(0.0)
#  txhash           :string
#  contract_address :string
#  fee              :decimal(, )      default(0.0)
#
class WithdrawCrypto < ApplicationRecord

  after_save :save_to_history
  before_save :all_those_downcase

  belongs_to :user
  validates :status, inclusion: { in: %w(open close fail), allow_nil: true, message: "%{value} bukan status yang benar" }

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

  def all_those_downcase
    self.contract_address = contract_address.downcase if !contract_address.nil?
    self.to_address       = to_address.downcase if !to_address.nil?
  end
end
