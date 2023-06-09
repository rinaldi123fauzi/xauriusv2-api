module V1
  class BuysController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request
    before_action :check_status_kyc

    def index
      buys = Buy.where(user_id: decoded_auth_token[:user_id]).order(:id => :desc)
      render json: {
        success: true,
        msg: "Data berhasil diambil.",
        data: buys
      }
    end

    def show
      buys = Buy.where(id: params[:id], user_id: decoded_auth_token[:user_id]).order(:id => :desc)
      render json: {
        success: true,
        msg: "Data detail berhasil diambil.",
        data: buys
      }
    end

    def create
      # Harga per satu XAU
      # harga diambil dari Chartprice.chartprice_buy
      harga_satu_xau = Chartprice.last.chartprice_buy.to_f

      user_id = decoded_auth_token[:user_id]

      # jalankan ini sebelum eksekusi kode kebawah
      set_user_balances(user_id) 

      # Cari User ID yang exists
      balances = Balance.where(user_id: user_id, currency: 'IDR')
      if balances.count == 1

        # Cari nilai balance IDR pertama
        balance = balances.first

        if balance.balance_value >= params[:amount_idr].to_f

          # hitung per harga satu XAU dan balance xau
          hitungXau = params[:amount_idr].to_f / harga_satu_xau
          
          # Tambah buy
          @buy = Buy.new
          @buy.amount_xau = hitungXau.to_f
          @buy.amount_idr = params[:amount_idr]
          @buy.price      = harga_satu_xau
          @buy.user_id    = user_id
          
          if @buy.save

            # Update balance IDR
            balance.balance_value = balance.balance_value - params[:amount_idr].to_f
            balance.save 
            
            # kita cari dulu xaurius user ini
            balance_xau = Balance.where(user_id: user_id, currency: 'XAU').first 

            sum_xau = hitungXau.to_f + balance_xau.balance_value 

            balance_xau.balance_value = sum_xau
            balance_xau.save 

            # dapatkan balances user yang ter-update (XAU dan IDR)
            user_balances = Balance.where(user_id: user_id)

            render json: {
              success: true, 
              msg:'Buys is saved', 
              data:{
                buy: @buy,
                balances: user_balances
              }
            }, status: :ok
          else
            render json: {success: false, msg:'Buys is not saved', data:@buy.errors}, status: :unprocessable_entity
          end
        else
          render json: {success: false, msg:'Saldo IDR Anda tidak mencukupi'}, status: :ok
        end
      else
        render json: {success: false, msg:'User tidak ditemukan'}, status: :ok
      end
    end

    private
    def buy_params
      params.require(:buy).permit(:spend,:amount_xau,:date,:amount_idr,:quantity,:status,:user_id)
    end

    def check_status_kyc
      profile = Profile.find_by_user_id(decoded_auth_token[:user_id])
      unless profile.status_kyc == "approved"
        render json: {
          success: false,
          status: 401,
          msg: "Status KYC Anda harus Approve"
        }, status: 401
      end
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
  
      render json: {
        success: false,
        status: 401,
        msg: "Anda harus login"
      }, status: 401 unless @current_user
    end

    # kadang-kadang user belum mempunyai XAU dan IDR, jadi disini fungsinya untuk memeriksa saja
    # jika belum ada, maka dibuatkan. Jika sudah ada, maka dibuarkan saja
    def set_user_balances(user_id) 

      if Balance.where(user_id: user_id, currency: 'XAU').count == 0
        Balance.create({
          user_id: user_id,
          currency: 'XAU',
          balance_value: 0
        })
      end

      if Balance.where(user_id: user_id, currency: 'IDR').count == 0
        Balance.create({
          user_id: user_id,
          currency: 'IDR',
          balance_value: 0
        })
      end

    end

  end
end
  