module Adm
  class WithdrawCryptosController < ApplicationController
    include ActionController::Cookies
    # before_action :authenticate_request

    def index
      withdraws = WithdrawCrypto.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: withdraws
      }
    end

    def show
      withdraws = WithdrawCrypto.find(params[:withdraw_crypto_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: withdraws
      }
    end

    def create
      @withdraws = WithdrawCrypto.new
      @withdraws.evm_network_id = params[:evm_network_id]
      @withdraws.address    = params[:address]
      @withdraws.xau_amount = params[:xau_amount]
      @withdraws.status     = "buat"
      @withdraws.user_id    = params[:user_id]
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
    end

    def update
      @withdraws = WithdrawCrypto.find(params[:withdraw_crypto_id])
      @withdraws.evm_network_id = params[:evm_network_id]
      @withdraws.address    = params[:address]
      @withdraws.xau_amount = params[:xau_amount]
      @withdraws.status     = "buat"
      @withdraws.user_id    = params[:user_id]
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
    end

    def destroy
      withdraw_crypto = WithdrawCrypto.find(params[:withdraw_crypto_id])
      withdraw_crypto.destroy!
      render json: {success: true, msg:'Withdraw Crypto has been deleted', data:withdraw_crypto}, status: :ok
    end

    private

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
      