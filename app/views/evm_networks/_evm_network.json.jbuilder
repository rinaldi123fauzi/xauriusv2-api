json.extract! evm_network, :id, :network_name, :rpc_url, :chain_id, :currency_symbol, :explorer, :created_at, :updated_at
json.url evm_network_url(evm_network, format: :json)
