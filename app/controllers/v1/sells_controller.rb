module V1
  class SellsController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request
    before_action :check_status_kyc

    def index
      sells = Sell.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data berhasil diambil.",
        data: sells
      }
    end

    def show
      sells = Sell.where(id: params[:id], user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data detail berhasil diambil.",
        data: sells
      }
    end

    def create
      # Harga per satu XAU
      harga_satu_xau = Chartprice.last.chartprice_sell.to_f
      user_id = decoded_auth_token[:user_id]

      balances = Balance.where(user_id: user_id, currency: 'XAU')

      if balances.count == 1

        balance = balances.first

        # cek balance
        if balance.balance_value.to_f >= params[:amount_xau].to_f

          # hitung per harga satu XAU dan balance xau
          hitungIdr = params[:amount_xau].to_f * harga_satu_xau

          # Tambah sell
          @sells = Sell.new
          @sells.amount_xau = params[:amount_xau]
          @sells.amount_idr = hitungIdr.to_f
          @sells.price = harga_satu_xau
          @sells.user_id = user_id
    
          if @sells.save

            # update balance XAU
            balance.balance_value = balance.balance_value - params[:amount_xau].to_f
            balance.save

            # kita cari dulu IDR user ini
            balances_idr = Balance.where(user_id: user_id, currency: 'IDR').first
            
            sum_idr = balances_idr.balance_value + hitungIdr.to_f

            balances_idr.balance_value = sum_idr
            balances_idr.save

            # dapatkan balances user yang ter-update (XAU dan IDR)
            user_balances = Balance.where(user_id: user_id)
            
            render json: {
              success: true, 
              msg:'Sells is saved', 
              data:{
                sells: @sells,
                balances: user_balances
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
      params.require(:sell).permit(:sell,:amount_xau,:date,:price,:quantity,:status,:user_id)
    end

    def decoded_auth_token
      if request.headers["JWT"]
        @decoded_auth_token ||= JsonWebToken.decode(request.headers["JWT"])
      else
        @decoded_auth_token ||= JsonWebToken.decode(cookies[:JWT])
      end
    end

    def check_status_kyc
      profile = Profile.find_by_user_id(decoded_auth_token[:user_id])
      unless profile.status_kyc == "approved"
        render json: {
          success: false,
          status: 401,
          msg: "Status KYC Anda harus Approve"
        }
      end
    end

    def authenticate_request
      if request.headers["JWT"]
        @current_user = AuthorizeApiRequest.call(request.headers["JWT"]).result
      else
        @current_user = AuthorizeApiRequest.call(cookies[:JWT]).result
      end
  
      render json: {
        success: false,
        status: 401,
        msg: "Anda harus login"
      } unless @current_user
    end

  end
end
  