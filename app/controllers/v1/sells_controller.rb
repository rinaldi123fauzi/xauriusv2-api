module V1
  class SellsController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      sells = Sell.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: sells
      }
    end
    def show
      sells = Sell.find_by_user_id(decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: sells
      }
    end
    def create
      @sells = Sell.new
      @sells.sell = params[:sell]
      @sells.summary = params[:summary]
      @sells.date = params[:date]
      @sells.price = params[:price]
      @sells.quantity = params[:quantity]
      @sells.status = params[:status]
      @sells.user_id = params[:user_id]
      if @sells.save
        render json: {success: true, message:'Sells is saved', data:@sells}, status: :ok
      else
        render json: {success: false, message:'Sells is not saved', data:@sells.errors}, status: :unprocessable_entity
      end
    end
    def update
      @sells = Sell.find(params[:id])
      @sells.update(sell: params[:sell])
      @sells.update(summary: params[:summary])
      @sells.update(date: params[:date])
      @sells.update(price: params[:price])
      @sells.update(quantity: params[:quantity])
      @sells.update(status: params[:status])
      @sells.update(user_id: params[:user_id])
      render json: {success: true, message:'Sells is update', data:@sells}, status: :ok
    end
    def destroy
      sells = Sell.find(params[:id])
      sells.destroy!
      render json: {success: true, message:'Sells has been deleted', data:sells}, status: :ok
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
  