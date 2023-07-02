Rails.application.routes.draw do
  resources :bank_users
  resources :auth_admins
  resources :evm_networks
  resources :banks
  resources :withdraw_cryptos
  resources :balances
  resources :businesses

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  namespace :adm do
    # Login
    scope :auth do
      post 'login'                            => 'auth#login'
      post 'register'                         => 'auth#register'
      get  'email-verification'               => 'auth#register_vercode'                  # submit kode verifikasi untuk memverifikasi emailnya (metode get jika langsung)
      post 'email-verification'               => 'auth#register_vercode'                  # submit kode verifikasi untuk memverifikasi emailnya (metode post, jika view pakai vuejs atau dari mobile app)
      post 'email-verification-token-request' => 'auth#email_verification_token_request'  # permintaan ulang kode verifikasi ke email
      post 'forgot-password'                  => 'auth#forgot_password'

      post 'change-password'                  => 'auth#change_password'
      post 'logout'                         => 'auth#destroy'
    end

    #Banks
    scope :banks do
      get '/'                                 => 'banks#index'
      post 'create'                           => 'banks#create'
      get 'detail'                            => 'banks#show'
      post 'update'                           => 'banks#update'
      delete 'delete'                         => 'banks#destroy'
    end

    #Balances
    scope :balances do
      get '/'                                 => 'balances#index'
      post 'create'                           => 'balances#create'
      get 'detail'                            => 'balances#show'
      post 'update'                           => 'balances#update'
      delete 'delete'                         => 'balances#destroy'
    end

    #Buys
    scope :buys do
      get '/'                                 => 'buys#index'
      post 'create'                           => 'buys#create'
      get 'detail'                            => 'buys#show'
      post 'update'                           => 'buys#update'
      delete 'delete'                         => 'buys#destroy'
    end

    #Deposit
    scope :deposits do
      get '/'                                 => 'deposits#index'
      post 'create'                           => 'deposits#create'
      get 'detail'                            => 'deposits#show'
      post 'update'                           => 'deposits#update'
      delete 'delete'                         => 'deposits#destroy'
    end

    

    #Profiles
    scope :profiles do
      get '/'                                 => 'profiles#index'
      post 'update'                           => 'profiles#update'
      get 'detail'                            => 'profiles#show'
      post 'create'                           => 'profiles#create'
      delete 'delete'                         => 'profiles#destroy'
    end

    #Sells
    scope :sells do
      post 'create'                           => 'sells#create'
      get '/'                                 => 'sells#index'
      get 'detail'                            => 'sells#show'
      post 'update'                           => 'sells#update'
      delete 'delete'                         => 'sells#destroy'
    end

    #Withdraws
    scope :withdraws do
      post 'create'                           => 'withdraws#create'
      get '/'                                 => 'withdraws#index'
      get 'detail'                            => 'withdraws#show'
      post 'update'                           => 'withdraws#update'
      delete 'delete'                         => 'withdraws#destroy'
    end

    #Withdraws Crypto
    scope :withdraw_cryptos do
      post 'create'                           => 'withdraw_cryptos#create'
      get '/'                                 => 'withdraw_cryptos#index'
      get 'detail'                            => 'withdraw_cryptos#show'
      post 'update'                           => 'withdraw_cryptos#update'
      delete 'delete'                         => 'withdraw_cryptos#destroy'
    end

    #Users
    scope :users do
      post 'create'                           => 'users#create'
      post 'update'                           => 'users#update'
      get '/'                                 => 'users#index'
      get 'detail'                            => 'users#show'
      delete 'delete'                         => 'users#destroy'
    end

    #Evm Networks
    scope :evm_networks do
      post 'create'                           => 'evm_networks#create'
      post 'update'                           => 'evm_networks#update'
      get '/'                                 => 'evm_networks#index'
      get 'detail'                            => 'evm_networks#show'
      delete 'delete'                         => 'evm_networks#destroy'
    end
  end

  namespace :v1 do

    # Admin
    namespace :admin do
      #Verify
      scope :verify do
        post 'approve-deposit'                => 'verify#approve_deposit'
        post 'approve-kyc'                    => 'verify#approve_kyc'
        post 'approve-withdraw'               => 'verify#approve_withdraw'
        post 'approve-withdraw-crypto'        => 'verify#approve_withdraw_crypto'
        post 'lock-unlock-bankuser'           => 'verify#bankUser'
      end

      #Bank
      scope :bank do
        get '/'                                 => 'bank#index'
        post 'create'                           => 'bank#create'
        post 'update'                           => 'bank#update'
        delete 'delete'                         => 'bank#destroy'
      end
    end

    #Auth
    scope :auth do
      post 'login'                            => 'auth#login'
      post 'register'                         => 'auth#register'
      get  'email-verification'               => 'auth#register_vercode'                  # submit kode verifikasi untuk memverifikasi emailnya (metode get jika langsung)
      post 'email-verification'               => 'auth#register_vercode'                  # submit kode verifikasi untuk memverifikasi emailnya (metode post, jika view pakai vuejs atau dari mobile app)
      post 'email-verification-token-request' => 'auth#email_verification_token_request'  # permintaan ulang kode verifikasi ke email
      post 'forgot-password'                  => 'auth#forgot_password'

      post 'change-password'                  => 'auth#change_password'
      post 'logout'                         => 'auth#destroy'
    end

    scope :blocks do 
      post 'coin-deposit-manual'         => 'blocks#coin_deposit_manual'         
      post 'erc20-deposit-manual'        => 'blocks#erc20_deposit_manual'         
      get  'used-ethereum-address-count' => 'blocks#used_ethereum_address_count'
      get  'all-ethereum-addresses'      => 'blocks#all_ethereum_addresses'
      post 'load-eth-address'            => 'blocks#load_eth_address'
    end

    # Charts
    scope :charts do 
      get '/'          => 'charts#index'
      get 'last-price' => 'charts#last_price'
    end

    # histories
    scope :histories do 
      get '/'       => 'histories#index'
      get 'detail'  => 'histories#show'
    end

    # Bank Users
    scope :bank_users do 
      get 'detail'     => 'bank_users#detail'
      post 'create'    => 'bank_users#create'
      put 'update'     => 'bank_users#update'
    end

    # Bank
    scope :bank do 
      get '/'     => 'bank#index'
    end

    # EvmNetwork
    get 'evm-networks'                        => 'evm_networks#index'

    #Balances
    scope :balances do
      get '/'                                 => 'balances#index'
    end

    #Buys
    scope :buys do
      get '/'                                 => 'buys#index'
      post 'create'                           => 'buys#create'
      get 'detail'                            => 'buys#show'
    end

    # Deposit
    # Deposit disini lebih mengacu kepada deposit Rupiah
    scope :deposits do
      get '/'                                 => 'deposits#index'
      post 'create'                           => 'deposits#create'
      get 'detail'                            => 'deposits#show'
      post 'upload-file'                      => 'deposits#uploadDeposit'
    end

    # Ccdeposits
    # Ini adalah Crypto deposit. 
    scope :ccdeposits do
      get  '/'                                => 'ccdeposits#index'
      get  'request-address'                  => 'ccdeposits#request_address'
    end

    #Profiles
    scope :profiles do
      get '/'                                 => 'profiles#index'
      post 'update'                           => 'profiles#update'
      get 'detail'                            => 'profiles#show'
      get 'evm-address'                       => 'profiles#evm_address'
    end

    #Sells
    scope :sells do
      post 'create'                           => 'sells#create'
      get '/'                                 => 'sells#index'
      get 'detail'                            => 'sells#show'
    end

    #Transfers
    scope :transfers do
      post 'create'                           => 'transfers#create'
      get '/'                                 => 'transfers#index'
      get 'detail'                            => 'transfers#show'
    end

    #Withdraws
    scope :withdraws do
      post 'create'                           => 'withdraws#create'
      get '/'                                 => 'withdraws#index'
      get 'detail'                            => 'withdraws#show'
    end

    #Withdraws Crypto
    scope :withdraw_crypto do
      post 'create'                           => 'withdraw_crypto#create'
      get '/'                                 => 'withdraw_crypto#index'
      get 'detail'                            => 'withdraw_crypto#show'
    end

    #Users
    scope :users do
      post 'update'                           => 'users#update'
      get '/'                                 => 'users#index'
      get 'detail'                            => 'users#show'
      delete 'delete'                         => 'users#destroy'
    end

    #Deposit EVM (Token)
    scope :evms do
      post 'erc20-deposit'  => 'evms#erc20_deposit'
      post 'erc20-withdraw' => 'evms#erc20_withdraw'
    end

    
  end
  
  #cara lama
  # namespace 'api' do
  #   namespace 'v1' do
  #     resources :deposits
  #     resources :buys
  #     resources :withdraws
  #     resources :transfers
  #     resources :profiles
  #     resources :sells
  #     resources :auth
  #     resources :users
  #   end
  # end
end
