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
end
