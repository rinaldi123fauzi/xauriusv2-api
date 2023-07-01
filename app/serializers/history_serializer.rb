# == Schema Information
#
# Table name: histories
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  table      :string
#  table_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class HistorySerializer < ActiveModel::Serializer
  attributes :id, 
  :user_id, 
  :table, 
  :table_id,
  :obj

  def obj 
    if self.object.table == 'buys'
      data = Buy.find(self.object.table_id)
      return data 
    elsif self.object.table == 'ccdeposits'
      data = Ccdeposit.find(self.object.table_id)
      return data
    elsif self.object.table == 'deposits'
      data = Deposit.find(self.object.table_id)
      return ActiveModelSerializers::SerializableResource.new(data, each_serializer: DepositSerializer)
    elsif self.object.table == 'sells'
      data = Sell.find(self.object.table_id)
      return data
    elsif self.object.table == 'transfers'
      data = Transfer.find(self.object.table_id)
      return data
    elsif self.object.table == 'withdraw_cryptos'
      data = WithdrawCrypto.find(self.object.table_id)
      return data
    elsif self.object.table == 'withdraws'
      data = Withdraw.find(self.object.table_id)
      return data
    end
  end
end
