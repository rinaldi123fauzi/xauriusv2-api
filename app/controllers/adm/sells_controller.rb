module Adm
  class SellsController < ApplicationController
    include ActionController::Cookies
    # before_action :authenticate_request

    def index
      sells = Sell.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: sells
      }
    end

    def show
      sells = Sell.find(params[:sell_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: sells
      }
    end

    def create
      @sells = Sell.new
      @sells.summary  = params[:summary]
      @sells.price    = params[:price]
      @sells.user_id  = params[:user_id]

      if @sells.save
        render json: {
          success: true, 
          msg:'Sells is saved', 
          data:{
            sells: @sells,
            balances: balance
          }
        }, status: :ok
      else
        render json: {success: false, msg:'Sells is not saved', data:@sells.errors}, status: :unprocessable_entity
      end
    end

    def update
      @sells = Sell.find(params[:sell_id])
      @sells.summary  = params[:summary]
      @sells.price    = params[:price]
      @sells.user_id  = params[:user_id]
      if @sells.save
        render json: {
          success: true, 
          msg:'Sells is saved', 
          data:{
            sells: @sells,
            balances: balance
          }
        }, status: :ok
      else
        render json: {success: false, msg:'Sells is not saved', data:@sells.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      sell = Sell.find(params[:sell_id])
      sell.destroy!
      render json: {success: true, msg:'Sell has been deleted', data:sell}, status: :ok
    end

    private
    def sell_params
      params.require(:sell).permit(:sell,:summary,:date,:price,:quantity,:status,:user_id)
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
    