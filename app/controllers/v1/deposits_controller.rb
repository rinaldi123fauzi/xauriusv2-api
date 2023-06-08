module V1
  class DepositsController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request
    before_action :check_status_kyc

    def index
      deposits = Deposit.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: deposits
      }
    end

    def show
      deposits = Deposit.find_by_user_id(decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: deposits
      }
    end

    def create
      @deposits = Deposit.new
      @deposits.name_bank = params[:name_bank]
      @deposits.total     = params[:total]
      @deposits.user_id   = decoded_auth_token[:user_id]
      @deposits.status    = "menunggu-pembayaran"
      if @deposits.save
        render json: {success: true, msg:'Deposits is saved', data:@deposits}, status: :ok
      else
        render json: {success: false, msg:'Deposits is not saved', data:@deposits.errors}, status: :unprocessable_entity
      end
    end

    private
    def deposit_params
      params.require(:deposit).permit(:name_bank,:unit_price,:quantity,:total,:date,:order, :user_id)
    end

    def check_status_kyc
      profile = Profile.find_by_user_id(decoded_auth_token[:user_id])
      unless profile.status_kyc == "approve"
        render json: { error: 'Status KYC Anda harus Approve' }, status: 401
      end
    end

    def decoded_auth_token
      if request.headers["JWT"]
        @decoded_auth_token ||= JsonWebToken.decode(request.headers["JWT"])
      else
        @decoded_auth_token ||= JsonWebToken.decode(cookies[:JWT])
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
  