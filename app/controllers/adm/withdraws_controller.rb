module Adm
  class WithdrawsController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      withdraws = Withdraw.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: withdraws
      }
    end

    def show
      withdraws = Withdraw.find(params[:withdraw_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: withdraws
      }
    end

    def create
      @withdraws = Withdraw.new
      @withdraws.bank_id        = params[:bank_id]
      @withdraws.account_number = params[:account_number]
      @withdraws.name           = params[:name]
      @withdraws.ammount        = params[:ammount]
      @withdraws.status         = "sedang-diproses"
      @withdraws.user_id        = params[:user_id]
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
    end

    def update
      @withdraws = Withdraw.find(params[:withdraw_id])
      @withdraws.bank_id        = params[:bank_id]
      @withdraws.account_number = params[:account_number]
      @withdraws.name           = params[:name]
      @withdraws.ammount        = params[:ammount]
      @withdraws.status         = "sedang-diproses"
      @withdraws.user_id        = params[:user_id]
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
    end

    def destroy
      withdraw = Withdraw.find(params[:withdraw_id])
      withdraw.destroy!
      render json: {success: true, msg:'Withdraw has been deleted', data:withdraw}, status: :ok
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
    