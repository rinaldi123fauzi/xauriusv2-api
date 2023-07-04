module V1
  class TransfersController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request
    before_action :check_status_kyc

    def index
      transfers = Transfer.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data berhasil diambil.",
        data: transfers
      }
    end

    def show
      transfers = Transfer.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data detail berhasil diambil.",
        data: transfers
      }
    end

    def create
      @transfers = Transfer.new
      @transfers.network = params[:network]
      @transfers.address_wallet = params[:address_wallet]
      @transfers.date = params[:date]
      @transfers.tx_hash = params[:tx_hash]
      @transfers.address = params[:address]
      @transfers.quantity = params[:quantity]
      @transfers.status = params[:status]
      @transfers.user_id = decoded_auth_token[:user_id]
      if @transfers.save
        render json: {success: true, msg:'Transfers is saved', data:@transfers}, status: :ok
      else
        render json: {success: false, msg:'Transfers is not saved', data:@transfers.errors}, status: :unprocessable_entity
      end
    end

    def update
      @transfers = Transfer.find_by_user_id(decoded_auth_token[:user_id])
      @transfers.network = params[:network]
      @transfers.address_wallet = params[:address_wallet]
      @transfers.date = params[:date]
      @transfers.tx_hash = params[:tx_hash]
      @transfers.address = params[:address]
      @transfers.quantity = params[:quantity]
      @transfers.status = params[:status]
      
      if @transfers.save
        render json: {success: true, msg:'Transfers is update', data:@transfers}, status: :ok
      else
        render json: {success: false, msg:'Transfers is not update', data:@transfers.errors}, status: :ok
      end
    end

    def destroy
      transfers = Transfer.find_by_user_id(decoded_auth_token[:user_id])
      transfers.destroy!
      render json: {success: true, msg:'Transfers has been deleted', data:transfers}, status: :ok
    end

    private
    def transfer_params
      params.require(:transfer).permit(:network,:address_wallet,:date,:tx_hash,:address,:quantity,:status,:user_id)
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
  