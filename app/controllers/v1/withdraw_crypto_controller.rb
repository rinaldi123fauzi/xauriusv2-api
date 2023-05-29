module V1
  class WithdrawCryptoController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request
    # before_action :check_status_kyc

    def index
      withdraws = WithdrawCrypto.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: withdraws
      }
    end

    def show
      withdraws = WithdrawCrypto.find_by_user_id(decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: withdraws
      }
    end

    def create
      @checkBalances = Balance.find_by_user_id(decoded_auth_token[:user_id])

      @withdraws = WithdrawCrypto.new
      @withdraws.address = params[:address]
      @withdraws.network = params[:network]
      @withdraws.xau_amount = params[:xau_amount]
      @withdraws.status = "buat"
      @withdraws.user_id = decoded_auth_token[:user_id]

      if @checkBalances.balance_xau >= params[:xau_amount].to_f
        if @withdraws.save
          render json: {
              success: true, 
              msg:'Withdraws Crypto is saved', 
              data:{
                withdraw: @withdraws,
                balance: @checkBalances
              }
            }, status: :ok
        else
          render json: {success: false, msg:'Withdraws Crypto is not saved', data:@withdraws.errors}, status: :unprocessable_entity
        end
      else
        render json: {
          success: false, 
          msg:'Balances XAU tidak mencukupi'
          }, status: :ok
      end
    end

    private

    def decoded_auth_token
      if request.headers["JWT"]
        @decoded_auth_token ||= JsonWebToken.decode(request.headers["JWT"])
      else
        @decoded_auth_token ||= JsonWebToken.decode(cookies[:JWT])
      end
    end

    def check_status_kyc
      profile = Profile.find_by_user_id(decoded_auth_token[:user_id])
      if profile.status_kyc == false
        render json: { error: 'Anda Harus KYC Terlebihdahulu' }, status: 401
      end
    end

    def authenticate_request
      if request.headers["JWT"]
        @current_user = AuthorizeApiRequest.call(request.headers["JWT"]).result
      else
        @current_user = AuthorizeApiRequest.call(cookies[:JWT]).result
      end
  
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end

  end
end
    