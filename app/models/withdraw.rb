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
#  bank_id        :bigint           not null
#
class Withdraw < ApplicationRecord

  after_save :save_to_history

  belongs_to :user
  belongs_to :bank
  validates :status, inclusion: { in: %w(sedang-diproses selesai), allow_nil: true, message: "%{value} bukan status yang benar" }

  private 

  def save_to_history 
    # cek di history, apakah sudah ada datanya
    thedata = History.where(user_id: self.user_id, table: 'withdraws', table_id: self.id)
    if thedata.count == 0
      History.create({
        user_id: self.user_id, 
        table: 'withdraws', 
        table_id: self.id
      })
    end
  end
end
