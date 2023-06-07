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
      chart = Chart.last

      @buys = Buy.new
      @buys.amount_xau = params[:amount_xau]
      @buys.amount_idr = params[:amount_idr]
      @buys.price      = chart.copen
      @buys.user_id    = params[:user_id]
      
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
      chart = Chart.last

      @buys = Buy.find(params[:buy_id])
      @buys.amount_xau = params[:amount_xau]
      @buys.amount_idr = params[:amount_idr]
      @buys.price      = chart.copen
      @buys.user_id    = params[:user_id]
      
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
      params.require(:buy).permit(:spend,:amount_xau,:date,:price,:quantity,:status,:user_id)
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
    