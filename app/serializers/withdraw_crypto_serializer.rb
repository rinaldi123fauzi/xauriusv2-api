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
class WithdrawCryptoSerializer < ActiveModel::Serializer
  attributes :id, :name_bank, :account_number, :name, :xau_amount, :status
  has_one :user
end
