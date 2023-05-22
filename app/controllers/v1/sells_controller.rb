module V1
  class SellsController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      sells = Sell.where(user_id: decoded_auth_token[:user_id])
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
      # Harga per satu XAU
      harga_satu_xau = 1000000

      balances = Balance.where(user_id: decoded_auth_token[:user_id])

      if balances.count == 1

        balance = balances.first

        # cek balance
        if balance.balance_xau.to_f >= params[:summary].to_f

          # hitung balance_xau
          sum = params[:summary].to_f * harga_satu_xau.to_f

          # update balance_value
          balance.balance_value = balance.balance_value + sum
          balance.balance_xau = balance.balance_xau - params[:summary].to_f
          balance.save

          # Tambah sell
          @sells = Sell.new
          @sells.summary = params[:summary]
          @sells.price = sum
          @sells.user_id = decoded_auth_token[:user_id]
    
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
        else
          render json: {
            success: false, 
            msg:'Balance XAU tidak mencukupi', 
            }, status: :ok
        end
      else
        render json: {
          success: false, 
          msg:'User tidak ditemukan', 
          }, status: :ok
      end
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
  