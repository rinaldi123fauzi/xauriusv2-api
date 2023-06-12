module V1
  class WithdrawCryptoController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request
    before_action :check_status_kyc

    def index
      withdraws = WithdrawCrypto.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: {
          withdraws: withdraws
        }
      }
    end

    def show
      withdraws = WithdrawCrypto.find_by_user_id(decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: {
          withdraws: withdraws
        }
      }
    end

    def create
      @balances = Balance.where(user_id: decoded_auth_token[:user_id], currency: 'XAU')

      @balance = @balances.first

      @withdraws = WithdrawCrypto.new
      @withdraws.evm_network_id = params[:evm_network_id]
      @withdraws.address = params[:address]
      @withdraws.xau_amount = params[:xau_amount]
      @withdraws.status = "buat"
      @withdraws.user_id = decoded_auth_token[:user_id]

      if @balance.balance_value >= params[:xau_amount].to_f
        if @withdraws.save
          render json: {
            success: true, 
            msg:'Withdraws Crypto is saved', 
            data:{
              withdraw: @withdraws,
              balance: @balance
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
      unless profile.status_kyc == "approved"
        render json: {
          success: false,
          status: 401,
          msg: "Status KYC Anda harus Approve"
        }
      end
    end

    def authenticate_request
      if request.headers["JWT"]
        @current_user = AuthorizeApiRequest.call(request.headers["JWT"]).result
      else
        @current_user = AuthorizeApiRequest.call(cookies[:JWT]).result
      end
  
      render json: {
        success: false,
        status: 401,
        msg: "Anda harus login"
      } unless @current_user
    end

  end
end
    