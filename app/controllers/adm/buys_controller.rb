module Adm
  class BuysController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      buys = Buy.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: buys
      }
    end

    def show
      buys = Buy.find(params[:buy_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: buys
      }
    end

    def create
      @buys = Buy.new
      @buys.summary = hitungXau.to_f
      @buys.price   = params[:price]
      @buys.user_id = params[:user_id]
      
      if @buys.save
        render json: {
          success: true, 
          msg:'Buys is saved', 
          data:{
            buys: @buys,
            balance: balance
          }
        }, status: :ok
      else
        render json: {success: false, msg:'Buys is not saved', data:@buys.errors}, status: :unprocessable_entity
      end
    end

    def update
      @buys = Buy.find(params[:buy_id])
      @buys.summary = hitungXau.to_f
      @buys.price   = params[:price]
      @buys.user_id = params[:user_id]
      
      if @buys.save
        render json: {
          success: true, 
          msg:'Buys is saved', 
          data:{
            buys: @buys,
            balance: balance
          }
        }, status: :ok
      else
        render json: {success: false, msg:'Buys is not saved', data:@buys.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      buys = Buy.find(params[:buy_id])
      buys.destroy!
      render json: {success: true, msg:'Buys has been deleted', data:buys}, status: :ok
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
    