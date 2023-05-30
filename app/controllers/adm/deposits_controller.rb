module Adm
  class DepositsController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      deposits = Deposit.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: deposits
      }
    end

    def show
      deposits = Deposit.find(params[:deposit_id])
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
      @deposits.user_id   = params[:user_id]
      @deposits.status    = "menunggu-pembayaran"
      if @deposits.save
        render json: {success: true, msg:'Deposits is saved', data:@deposits}, status: :ok
      else
        render json: {success: false, msg:'Deposits is not saved', data:@deposits.errors}, status: :unprocessable_entity
      end
    end

    def update
      @deposits = Deposit.find(params[:deposit_id])
      @deposits.name_bank = params[:name_bank]
      @deposits.total     = params[:total]
      @deposits.user_id   = params[:user_id]
      @deposits.status    = "menunggu-pembayaran"
      if @deposits.save
        render json: {success: true, msg:'Deposits is saved', data:@deposits}, status: :ok
      else
        render json: {success: false, msg:'Deposits is not saved', data:@deposits.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      deposits = Deposit.find(params[:deposit_id])
      deposits.destroy!
      render json: {success: true, msg:'Deposits has been deleted', data:deposits}, status: :ok
    end

    private
    def deposit_params
      params.require(:deposit).permit(:name_bank,:unit_price,:quantity,:total,:date,:order, :user_id)
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
        @current_user = AuthAdminRequest.call(request.headers["JWT"]).result
      else
        @current_user = AuthAdminRequest.call(cookies[:JWT]).result
      end
  
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end

  end
end
    