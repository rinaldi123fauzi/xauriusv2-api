# == Schema Information
#
# Table name: evm_networks
#
#  id              :bigint           not null, primary key
#  network_name    :string
#  rpc_url         :string
#  chain_id        :integer
#  currency_symbol :string
#  explorer        :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class EvmNetworkSerializer < ActiveModel::Serializer
  attributes :id, :network_name, :rpc_url, :chain_id, :currency_symbol, :explorer
end
