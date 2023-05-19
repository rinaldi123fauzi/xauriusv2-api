Rails.application.routes.draw do
  resources :balances
  resources :businesses

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  post 'authenticate', to: 'authentication#authenticate'

  namespace :v1 do

    # Admin
    namespace :admin do
      #Verify
      scope :verify do
        post 'approve-deposit'                => 'verify#approve_deposit'
        post 'approve-kyc'                    => 'verify#approve_kyc'
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

    #Balances
    scope :balances do
      get '/'                                 => 'balances#index'
    end

    #Buys
    scope :buys do
      get '/'                                 => 'buys#index'
      post 'create'                           => 'buys#create'
      post 'update'                           => 'buys#update'
      get 'detail'                            => 'buys#show'
      delete 'delete'                         => 'buys#destroy'
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
