module Adm
  class BalancesController < ApplicationController
    include ActionController::Cookies
    # before_action :authenticate_request

    def index
      @balances = Balance.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: @balances
      }
    end

    def show
      @balances = Balance.find(params[:balance_id])
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: @balances
      }
    end

    def create
      balance = Balance.new
      balance.user_id       = params[:user_id] if params[:user_id] && params[:user_id] != ""
      balance.currency      = params[:currency] if params[:currency] && params[:currency] != ""
      balance.balance_xau   = params[:balance_xau] if params[:balance_xau] && params[:balance_xau] != ""
      balance.balance_value = params[:balance_value] if params[:balance_value] && params[:balance_value] != ""
      if @deposits.save
        render json: {success: true, msg:'Deposits is saved', data:@deposits}, status: :ok
      else
        render json: {success: false, msg:'Deposits is not saved', data:@deposits.errors}, status: :unprocessable_entity
      end
    end

    def update
      balance = Balance.find(params[:balance_id])
      balance.user_id       = params[:user_id] if params[:user_id] && params[:user_id] != ""
      balance.currency      = params[:currency] if params[:currency] && params[:currency] != ""
      balance.balance_xau   = params[:balance_xau] if params[:balance_xau] && params[:balance_xau] != ""
      balance.balance_value = params[:balance_value] if params[:balance_value] && params[:balance_value] != ""
      if @deposits.save
        render json: {success: true, msg:'Deposits is saved', data:@deposits}, status: :ok
      else
        render json: {success: false, msg:'Deposits is not saved', data:@deposits.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      balance = Balance.find(params[:balance_id])
      balance.destroy!
      render json: {success: true, msg:'Balance has been deleted', data:balance}, status: :ok
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