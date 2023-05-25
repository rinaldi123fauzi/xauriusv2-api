module V1
  module Admin
    class BankController < ApplicationController
      include ActionController::Cookies
      # before_action :authenticate_request

      def index
        @bank = Bank.all
        render json: {
            success: true,
            msg: "Data barhasil diambil.",
            data: @bank
        }
      end

      def create
        bank = Bank.new
        bank.name_bank = params[:name_bank]

        if bank.save
            render json: {
                success: true,
                msg: "Data barhasil disimpan.",
                data: bank
            }       
        else
            render json: {
                success: false,
                msg: "Data gagal disimpan.",
                data: bank.errors
            }   
        end
      end

      def update
        bank = Bank.find(params[:bank_id])
        bank.name_bank = params[:name_bank]

        if bank.save
            render json: {
                success: true,
                msg: "Data barhasil disimpan.",
                data: bank
            }       
        else
            render json: {
                success: false,
                msg: "Data gagal disimpan.",
                data: bank.errors
            }   
        end
      end

      def destroy
        bank = Bank.find(params[:id]).destroy
        if bank
            render json: {
                success: true,
                msg: "Data barhasil dihapus."
            }  
        else
            render json: {
                success: false,
                msg: "Data barhasil dihapus.",
                data: bank.errors
            }
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
end