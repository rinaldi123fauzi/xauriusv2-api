Rails.application.routes.draw do
  resources :balances
  resources :businesses

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  resources :users
  resources :profiles
  resources :transfers
  resources :sells
  resources :buys
  resources :withdraws
  resources :deposits
  
  post 'authenticate', to: 'authentication#authenticate'

  namespace :v1 do
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

    #KYC
    scope :kyc do
      post 'update'                           => 'kyc#edit_kyc'
    end

    #Balances
    scope :balances do
      get '/'                                 => 'balances#index'
    end

    #Buys
    scope :buys do
      post 'create'                           => 'buys#create'
      post 'update'                           => 'buys#update'
      get '/'                                 => 'buys#index'
      get 'detail'                            => 'buys#show'
      delete 'delete'                         => 'buys#destroy'
    end

    #Deposit
    scope :deposits do
      post 'create'                           => 'deposits#create'
      post 'update'                           => 'deposits#update'
      get '/'                                 => 'deposits#index'
      get 'detail'                            => 'deposits#show'
      delete 'delete'                         => 'deposits#destroy'
    end

    #Profiles
    scope :profiles do
      post 'create'                           => 'profiles#create'
      post 'update'                           => 'profiles#update'
      get '/'                                 => 'profiles#index'
      get 'detail'                            => 'profiles#show'
      delete 'delete'                         => 'profiles#destroy'
    end

    #Sells
    scope :sells do
      # post 'create'                           => 'sells#create'
      post 'update'                           => 'sells#update'
      get '/'                                 => 'sells#index'
      get 'detail'                            => 'sells#show'
      # delete 'delete'                         => 'sells#destroy'
    end

    #Transfers
    scope :transfers do
      post 'create'                           => 'transfers#create'
      post 'update'                           => 'transfers#update'
      get '/'                                 => 'transfers#index'
      get 'detail'                            => 'transfers#show'
      delete 'delete'                         => 'transfers#destroy'
    end

    #Withdraws
    scope :withdraws do
      post 'save'                             => 'withdraws#create'
      post 'update'                           => 'withdraws#update'
      get '/'                                 => 'withdraws#index'
      get 'detail'                            => 'withdraws#show'
      delete 'delete'                         => 'withdraws#destroy'
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
