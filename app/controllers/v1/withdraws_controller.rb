module V1
  class WithdrawsController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request
    before_action :check_status_kyc

    def index
      withdraws = Withdraw.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data berhasil diambil.",
        data: withdraws
      }
    end

    def show
      withdraws = Withdraw.where(id: params[:id], user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data detail berhasil diambil.",
        data: withdraws
      }
    end

    def create
      @checkBalances = Balance.where(user_id: decoded_auth_token[:user_id], currency: 'IDR')
      @balance = @checkBalances.first

      @withdraws = Withdraw.new
      @withdraws.bank_id = params[:bank_id]
      @withdraws.account_number = params[:account_number]
      @withdraws.name = params[:name]
      @withdraws.ammount = params[:ammount]
      @withdraws.status = "sedang-diproses"
      @withdraws.user_id = decoded_auth_token[:user_id]

      if @balance.balance_value.to_f >= params[:ammount].to_f
        if @withdraws.save
          render json: {
              success: true, 
              msg:'Withdraws is saved', 
              data:{
                withdraw: @withdraws,
                balance: @checkBalances
              }
            }, status: :ok
        else
          render json: {success: false, msg:'Withdraws is not saved', data:@withdraws.errors}, status: :unprocessable_entity
        end
      else
        render json: {
          success: false, 
          msg:'Balances IDR tidak mencukupi'
          }, status: :ok
      end
    end

    private
    def withdraw_params
      params.require(:withdraw).permit(:name_bank,:account_number,:cash_balance,:ammount,:date,:withdraw,:status,:user_id)
    end

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
      }, status: 401 unless @current_user
    end

  end
end
  