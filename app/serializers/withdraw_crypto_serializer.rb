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
class WithdrawCryptoSerializer < ActiveModel::Serializer
  attributes :id,
    :status,
    :user_id,
    :to_address,
    :evm_network_id,
    :currency,
    :amount,
    :amount_after_fee,
    :txid,
    :contract_address,
    :fee,
    :created_at,
    :updated_at


  has_one :user
end
