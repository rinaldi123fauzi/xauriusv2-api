module V1
  class BuysController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      buys = Buy.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: buys
      }
    end

    def show
      buys = Buy.find_by_user_id(decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: buys
      }
    end

    def create
      # Harga per satu XAU
      harga_satu_xau = 1000000

      # Cari User ID yang exists
      balance = Balance.where(user_id: decoded_auth_token[:user_id])
      if balance.count == 1

        # Cari nilai balance
        balance = Balance.find_by_user_id(decoded_auth_token[:user_id])
        if balance.balance_value > params[:price].to_f
          
          # hitung per harga satu XAU
          hitungXau = params[:price].to_f / harga_satu_xau
          
          # Update Balance
          balance.balance_value = balance.balance_value - params[:price].to_f
          balance.save

          # Tambah buy
          @buys = Buy.new
          @buys.summary = hitungXau.to_f
          @buys.price = params[:price]
          @buys.status = "berhasil"
          @buys.user_id = decoded_auth_token[:user_id]
          
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
        else
          render json: {success: false, msg:'Balance anda tidak mencukupi', data:@buys}, status: :ok
        end
      else
        render json: {success: false, msg:'User tidak ditemukan'}, status: :ok
      end
    end

    # def update
    #   @buys = Buy.find_by_user_id(decoded_auth_token[:user_id])
    #   @buys.spend = params[:spend]
    #   @buys.summary = params[:summary]
    #   @buys.date = params[:date]
    #   @buys.price = params[:price]
    #   @buys.quantity = params[:quantity]
    #   @buys.status = params[:status]
    #   if @buys.save
    #     render json = {success: true, msg:'Buys is update', data:@buys}, status: :ok
    #   else
    #     render json = {success: false, msg:'Buys is not update', data:@buys.errors}, status: :ok
    #   end
    # end

    # def destroy
    #   buys = Buy.find_by_user_id(decoded_auth_token[:user_id])
    #   buys.destroy!
    #   render json: {success: true, msg:'Buys has been deleted', data:buys}, status: :ok
    # end

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
        @current_user = AuthorizeApiRequest.call(request.headers["JWT"]).result
      else
        @current_user = AuthorizeApiRequest.call(cookies[:JWT]).result
      end
  
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end

  end
end
  