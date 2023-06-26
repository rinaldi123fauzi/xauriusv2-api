module V1
  module Admin
    class VerifyController < ApplicationController
      include ActionController::Cookies

      # KHUSUS UNTUK DEVELOPMENT SAJA 
      def approve_deposit 
        deposit_id = params[:deposit_id]
        status = params[:status]

        # cari deposit ID yang sedang file-upload
        deposits = Deposit.where(id: deposit_id, status: 'file-upload')

        if deposits.count == 1 
          # kode lanjut 
          if status == "terbayar"
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
  
            balance_after = balance_awal.to_f + deposit.total.to_f
  
            balance_obj.balance_value = balance_after
            balance_obj.save 
  
            deposit.status = status
            deposit.save 
  
            render json: {
              success: true, 
              msg: 'Deposits is verified', 
              data: {
                balance: balance_obj,
                deposit: ActiveModelSerializers::SerializableResource.new(deposit, each_serializer: DepositSerializer)
              }
            }, status: :ok
          elsif status == "create-file"
            deposit.status = status
            deposit.save 
  
            render json: {
              success: true, 
              msg: 'Deposits is pending', 
              data: {
                balance: balance_obj,
                deposit: ActiveModelSerializers::SerializableResource.new(deposit, each_serializer: DepositSerializer)
              }
            }, status: :ok
          else
            render json: {success: false, msg: 'Status wajib diisi'}, status: :ok 
          end

        else  
          render json: {success: false, msg: 'Mungkin status sudah terbayar'}, status: :ok
        end
      end

      def approve_kyc
        user_id = params[:user_id]
        profiles = Profile.where(user_id: user_id)
        if profiles.count == 1
          profile = profiles.first
          if profile.status_kyc == "review"
            profile.status_kyc = params[:status_kyc]
            if profile.save

              # INI PERLU DIMASUKKAN NANTI.
              # KETIKA USER DI APPROVE KYC, MAKA DIBUAT JUGA ADDRESS DIA 
              # 1. Cek apakah user ini sudah punya address (Paraniod tipe. padahal disini kan ini baru approve KYC. Tetapi metode ini lebih baik)
              # Periksa terlebih dahulu apakah user ini sudah punya adress atau belum.
              datas = BlockEthAddr.where(user_id: user_id)

              if datas.count == 0

                # periksa apakah masih ada address yang nganggur 
                addrs = BlockEthAddr.where("user_id = 0 or user_id is null")

                if addrs.count > 0
                  addr = BlockEthAddr.where("user_id = 0 or user_id is null").first 
                  addr.user_id = user_id
                  addr.save 
                else  
                  # TODO: kirim email kepada admin untuk load address baru
                end
              end

              # semua respon langsung success
              if params[:status_kyc] == "approved"
                render json: {success: true, msg:'Selamat! KYC Anda telah telah sukses', data: ActiveModelSerializers::SerializableResource.new(profile, each_serializer: ProfileSerializer)}, status: :ok
              elsif params[:status_kyc] == "rejected"
                render json: {success: true, msg:'Maaf! KYC Anda belum disetujui. Silakan coba lagi.', data: ActiveModelSerializers::SerializableResource.new(profile, each_serializer: ProfileSerializer)}, status: :ok
              end
            else
              render json: {success: false, msg:'KYC gagal verifikasi', data: profile.error}, status: :ok
            end
          else
            render json: {success: false, msg:'KYC sudah verified'}, status: :ok
          end
        else
          render json: {success: false, msg:'Profile tidak ditemukan'}, status: :ok
        end
      end

      # approve withdraw rupiah
      def approve_withdraw
        withdraw_id = params[:withdraw_id]
        
        withdraws = Withdraw.where(id: withdraw_id, status: 'sedang-diproses')

        # cek withdraws
        if withdraws.count == 1
          withdraw = withdraws.first

          balances = Balance.where(user_id: withdraw.user_id, currency: 'IDR')

          balance = balances.first

          # proses pengurangan balance
          sum = balance.balance_value - withdraw.ammount
          balance.balance_value = sum
          balance.save
          
          # ubah status
          withdraw.status = 'selesai'
          withdraw.save

          render json: {
              success: true, 
              msg: 'Withdraw success',
              data:{
                withdraw: withdraw,
                balance: balance
              }
            }, status: :ok
        else
          render json: {success: false, msg: 'Mungkin status sudah selesai'}, status: :ok
        end
      end

      # approve withdraw crypto
      def approve_withdraw_crypto
        withdraw_id = params[:withdraw_crypto_id]
        
        withdraws = WithdrawCrypto.where(id: withdraw_id, status: 'buat')

        # cek withdraws
        if withdraws.count == 1
          withdraw = withdraws.first

          balances = Balance.where(user_id: withdraw.user_id, currency: 'XAU')

          balance = balances.first

          # proses pengurangan balance
          sum = balance.balance_value - withdraw.xau_amount
          balance.balance_value = sum
          balance.save
          
          # ubah status
          withdraw.status = 'selesai'
          withdraw.save

          render json: {
              success: true, 
              msg: 'Withdraw Crypto success',
              data:{
                withdraw: withdraw,
                balance: balance
              }
            }, status: :ok
        else
          render json: {success: false, msg: 'Mungkin status sudah selesai'}, status: :ok
        end
      end

      # Lock / Unlock Bank Users
      def bankUser
        bank_users = BankUser.where(id: params[:bank_user_id])
        bank_user = bank_users.first
        bank_user.status = params[:status]
        if bank_user.save
          render json:{
            success: true,
            msg: "Status bank users is saved",
            data: bank_users
          }
        else
          render json:{
            success: false,
            msg: "Status bank user is not save",
            data: bank_user.errors
          }
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