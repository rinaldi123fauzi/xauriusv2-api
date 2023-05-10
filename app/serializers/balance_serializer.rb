# == Schema Information
#
# Table name: balances
#
#  id            :bigint           not null, primary key
#  user_id       :bigint           not null
#  balance_value :decimal(, )
#  currency      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class BalanceSerializer < ActiveModel::Serializer
  attributes :id, :balance_value, :currency
  has_one :user
end
