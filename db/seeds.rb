# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Oadm.create_with({
  oadm_email: "super@email.com",
  oadm_name: "Super Admin",
  oadm_password: "$2a$12$6Mn0PDslbrc7YquS0fEYVu23YfGt18qwXvN5xwhYOD8KJbpAJPvQ.",
  oadm_status: "active"
}).find_or_create_by!(oadm_email: "super@email.com")

User.create_with({
    username: "superadmin",
    password: "123456",
    name: "superadmin",
    email: "superadmin@gmail.com"
}).find_or_create_by!(email: "superadmin@gmail.com")

EvmNetwork.create_with({
  network_name: "Ethereum Mainnet",    
  rpc_url: "https://patient-prettiest-morning.discover.quiknode.pro/6ef1acc4c3f290ff6a896a0505bb1ba77237f976/",          
  chain_id: 1,         
  currency_symbol: "ETH",
  explorer: "https://etherscan.io"
}).find_or_create_by!(chain_id: 1)

EvmNetwork.create_with({
  network_name: "Goerli Test Network",    
  rpc_url: "https://goerli.infura.io/v3/6bdb8b181bcf464790769e185b4d7a76",          
  chain_id: 5,         
  currency_symbol: "GoerliETH",
  explorer: "https://goerli.etherscan.io"
}).find_or_create_by!(chain_id: 5)

EvmNetwork.create_with({
  network_name: "Smarchain",    
  rpc_url: "https://1rpc.io/bnb",          
  chain_id: 56,         
  currency_symbol: "BNB",
  explorer: "https://bscscan.com"
}).find_or_create_by!(chain_id: 56)

EvmNetwork.create_with({
  network_name: "Smarchain Testnet",    
  rpc_url: "https://data-seed-prebsc-2-s1.binance.org:8545",          
  chain_id: 97,         
  currency_symbol: "tBNB",
  explorer: "https://testnet.bscscan.com"
}).find_or_create_by!(chain_id: 97)

EvmNetwork.create_with({
  network_name: "Arbitrum Goerli Testnet",    
  rpc_url: "https://goerli-rollup.arbitrum.io/rpc",          
  chain_id: 421613,         
  currency_symbol: "ETH",
  explorer: "https://goerli.arbiscan.io/"
}).find_or_create_by!(chain_id: 421613)

EvmNetwork.create_with({
  network_name: "Arbitrum Nova Mainnet",    
  rpc_url: "https://nova.arbitrum.io/rpc",          
  chain_id: 42170,         
  currency_symbol: "ETH",
  explorer: "https://nova.arbiscan.io/"
}).find_or_create_by!(chain_id: 42170)

EvmNetwork.create_with({
  network_name: "Arbitrum One Mainnet",    
  rpc_url: "https://arb1.arbitrum.io/rpc",          
  chain_id: 42161,         
  currency_symbol: "ETH",
  explorer: "https://arbiscan.io/"
}).find_or_create_by!(chain_id: 42161)
