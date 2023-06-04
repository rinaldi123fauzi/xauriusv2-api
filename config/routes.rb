Rails.application.routes.draw do
  resources :evm_networks
  resources :banks
  resources :withdraw_cryptos
  resources :balances
  resources :businesses

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  # TODO: Sepertinya ini gak ada deh
  post 'authenticate', to: 'authentication#authenticate'

  namespace :v1 do

    # Admin
    namespace :admin do
      #Verify
      scope :verify do
        post 'approve-deposit'                => 'verify#approve_deposit'
        post 'approve-kyc'                    => 'verify#approve_kyc'
        post 'approve-withdraw'               => 'verify#approve_withdraw'
        post 'approve-withdraw-crypto'        => 'verify#approve_withdraw_crypto'
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
      post 'signout'                          => 'auth#destroy'
    end

    scope :blocks do 
      post 'coin-deposit-manual'         => 'blocks#coin_deposit_manual'         
      post 'erc20-deposit-manual'        => 'blocks#erc20_deposit_manual'         
      get  'used-ethereum-address-count' => 'blocks#used_ethereum_address_count'
      get  'all-ethereum-addresses'      => 'blocks#all_ethereum_addresses'
      post 'load-eth-address'            => 'blocks#load_eth_address'
    end

    scope :charts do 
      get '/'          => 'charts#index'
      get 'last-price' => 'charts#last_price'
    end

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

    #Deposit
    scope :deposits do
      get '/'                                 => 'deposits#index'
      post 'create'                           => 'deposits#create'
      get 'detail'                            => 'deposits#show'
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
