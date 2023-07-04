class EvmTokenTransferService  < ApplicationService
  attr_accessor :contract_address, :to, :amount, :rpc_url

  def initialize(contract_address, to, amount, rpc_url)
    @contract_address = contract_address
    @to = to
    @amount = amount
    @rpc_url = rpc_url
  end

  # {
  #   "success": true,
  #   "msg": "",
  #   "data": {
  #     "blockHash": "0x198a04ae4ebaf7a4282eeafdbd66a60e39b216700c85a557a8ec920ae54d4aba",
  #     "blockNumber": 11563883,
  #     "contractAddress": null,
  #     "cumulativeGasUsed": 4092989,
  #     "effectiveGasPrice": "0x60a9ebd5",
  #     "from": "0x6264572d84fa67981a3cc4a4ba2b225f50573e37",
  #     "gasUsed": 51597,
  #     "logsBloom": "0x00000000010000000000002000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000008000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000002000000000000000000000000000000000000000000000000002000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000002000000000",
  #     "status": true,
  #     "to": "0x1be14238573eb4bfcc9277b762dcde117206b33c",
  #     "transactionHash": "0x9ccc0f7c691f7ed40658ee5cd94ac3f8f95442cac1056b2514e5afb11d7ce27a",
  #     "transactionIndex": 22,
  #     "type": "0x0",
  #     "events": {
  #       "Transfer": {
  #         "address": "0x1bE14238573eb4BFCC9277b762DcDE117206b33c",
  #         "blockHash": "0x198a04ae4ebaf7a4282eeafdbd66a60e39b216700c85a557a8ec920ae54d4aba",
  #         "blockNumber": 11563883,
  #         "logIndex": 16,
  #         "removed": false,
  #         "transactionHash": "0x9ccc0f7c691f7ed40658ee5cd94ac3f8f95442cac1056b2514e5afb11d7ce27a",
  #         "transactionIndex": 22,
  #         "id": "log_547a1fd0",
  #         "returnValues": {
  #           "0": "0x6264572d84Fa67981A3Cc4a4ba2B225f50573E37",
  #           "1": "0x75d33dBF5A9145e781BC3B4FECFA414746226c8c",
  #           "2": "1000000300000000000",
  #           "from": "0x6264572d84Fa67981A3Cc4a4ba2B225f50573E37",
  #           "to": "0x75d33dBF5A9145e781BC3B4FECFA414746226c8c",
  #           "value": "1000000300000000000"
  #         },
  #         "event": "Transfer",
  #         "signature": "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
  #         "raw": {
  #           "data": "0x0000000000000000000000000000000000000000000000000de0b6f980c8b800",
  #           "topics": [
  #             "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
  #             "0x0000000000000000000000006264572d84fa67981a3cc4a4ba2b225f50573e37",
  #             "0x00000000000000000000000075d33dbf5a9145e781bc3b4fecfa414746226c8c"
  #           ]
  #         }
  #       }
  #     }
  #   }
  # }
  # TODO: Ganti dengan call URL internal saja!
  def call  

    puts ENV.fetch('DOMAIN_BC_EVM')
    
    res = HTTParty.post(
      "#{ENV.fetch('DOMAIN_BC_EVM')}/v1/token/transfer", 
      :headers => {'Content-Type'=>'application/json'}, 
      :body => {
        password: ENV.fetch('INTERNAL_PASSWORD'),
        contractAddress: @contract_address,
        addressTo: @to,
        amount: @amount,
        rpc_url: @rpc_url
      }.to_json,
    )

    return res
  end
end