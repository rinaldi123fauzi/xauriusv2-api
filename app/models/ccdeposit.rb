# == Schema Information
#
# Table name: ccdeposits
#
#  id                           :bigint           not null, primary key
#  user_id                      :bigint
#  ccdeposit_amount             :decimal(, )
#  ccdeposit_confirmation_count :bigint
#  ccdeposit_data               :text
#  ccdeposit_status             :string
#  ccdeposit_txhash             :string
#  ccurrency_symbol             :string
#  evm_chain_id                 :bigint
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
class Ccdeposit < ApplicationRecord
  after_save :save_to_history

  private 

  def save_to_history 
    # cek di history, apakah sudah ada datanya
    thedata = History.where(user_id: self.user_id, table: 'ccdeposits', table_id: self.id)
    if thedata.count == 0
      History.create({
        user_id: self.user_id, 
        table: 'ccdeposits', 
        table_id: self.id
      })
    end
  end
end
