module Adm
  class BanksController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      bank = Bank.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: bank
      }
    end

    def show
      bank = Bank.where(id: params[:bank_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: bank
      }
    end

    def create
      bank = Bank.new
      bank.name_bank       = params[:name_bank]
      bank.name_account    = params[:name_account]
      bank.number_rekening = params[:number_rekening]
      
      if bank.save
        render json: {
          success: true, 
          msg:'Banks is saved', 
          data: bank
        }, status: :ok
      else
        render json: {success: false, msg:'Banks is not saved', data:@buys.errors}, status: :unprocessable_entity
      end
    end

    def update
      bank = Bank.find(params[:bank_id])
      bank.name_bank       = params[:name_bank]
      bank.name_account    = params[:name_account]
      bank.number_rekening = params[:number_rekening]

      if bank.save
        render json: {
          success: true, 
          msg:'Banks is saved', 
          data: bank
        }, status: :ok
      else
        render json: {success: false, msg:'Banks is not saved', data:@buys.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      bank = Bank.find(params[:bank_id])
      bank.destroy!
      render json: {success: true, msg:'Banks has been deleted', data:bank}, status: :ok
    end

    private
    def buy_params
      params.require(:buy).permit(:spend,:summary,:date,:price,:quantity,:status,:user_id)
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
      