module V1
  module Admin
    class VerifyController < ApplicationController
      include ActionController::Cookies

      # KHUSUS UNTUK DEVELOPMENT SAJA 
      def approve_deposit 
        deposit_id = params[:deposit_id]

        # cari deposit ID yang sedang menunggu-pembayaran
        deposits = Deposit.where(id: deposit_id, status: 'menunggu-pembayaran')

        if deposits.count == 1 
          # kode lanjut 
          deposit = deposits.first 

          balances = Balance.where(user_id: deposit.user_id, currency: 'IDR')

          if balances.count == 0
            Balance.create({
              user_id: deposit.user_id,
              currency: 'IDR',
              balance_value: 0
            })
          end

          balance_obj = Balance.where(user_id: deposit.user_id, currency: 'IDR').first 

          # balance awal 
          balance_awal = balance_obj.balance_value

          balance_after = balance_awal + deposit.total

          balance_obj.balance_value = balance_after
          balance_obj.save 

          deposit.status = 'terbayar'
          deposit.save 

          render json: {
            success: true, 
            msg: 'Deposits is verified', 
            data: {
              balance: balance_obj,
              deposit: deposit
            }
          }, status: :ok

        else  
          render json: {success: false, msg: 'Mungkin status sudah terbayar'}, status: :ok
        end
      end

      def approve_kyc
        user_id = params[:user_id]
        profiles = Profile.where(user_id: user_id)
        if profiles.count == 1
          profile = profiles.first
          if profile.status_kyc == false
            profile.status_kyc = true
            if profile.save
              render json: {success: true, msg:'KYC Terverifikasi', data: ActiveModelSerializers::SerializableResource.new(profile, each_serializer: ProfileSerializer)}, status: :ok
            else
              render json: {success: false, msg:'KYC gagal verifikasi', data: profile.error}, status: :ok
            end
          else
            render json: {success: false, msg:'KYC Sudah Terverifikasi'}, status: :ok
          end
        else
          render json: {success: false, msg:'Profile tidak ditemukan'}, status: :ok
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