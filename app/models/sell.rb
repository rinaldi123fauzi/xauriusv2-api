# == Schema Information
#
# Table name: sells
#
#  id         :bigint           not null, primary key
#  amount_xau :decimal(, )
#  price      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#  amount_idr :decimal(, )
#
class Sell < ApplicationRecord

  after_save :save_to_history

  belongs_to :user

  private 

  def save_to_history 
    # cek di history, apakah sudah ada datanya
    thedata = History.where(user_id: self.user_id, table: 'sells', table_id: self.id)
    if thedata.count == 0
      History.create({
        user_id: self.user_id, 
        table: 'sells', 
        table_id: self.id
      })
    end
  end
end
