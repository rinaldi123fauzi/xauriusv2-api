# == Schema Information
#
# Table name: block_evm_tokens
#
#  id                :bigint           not null, primary key
#  chain_id          :bigint
#  contract_address  :string
#  contract_decimals :integer
#  tracking          :boolean
#  token_name        :string
#  token_symbol      :string
#  currency_id       :bigint
#  wd_fee            :decimal(, )
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class BlockEvmToken < ApplicationRecord
end
