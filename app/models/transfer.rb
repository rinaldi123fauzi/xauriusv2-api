# == Schema Information
#
# Table name: transfers
#
#  id             :bigint           not null, primary key
#  network        :string
#  address_wallet :string
#  date           :datetime
#  tx_hash        :string
#  address        :string
#  quantity       :decimal(, )
#  status         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
class Transfer < ApplicationRecord

  after_save :save_to_history

  belongs_to :user

  private 

  def save_to_history 
    # cek di history, apakah sudah ada datanya
    thedata = History.where(user_id: self.user_id, table: 'transfers', table_id: self.id)
    if thedata.count == 0
      History.create({
        user_id: self.user_id, 
        table: 'transfers', 
        table_id: self.id
      })
    end
  end
end
