module V1
  class BankUsersController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request
    before_action :check_status_kyc

    def detail
      @bank_users = BankUser.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data bank user berhasil diambil.",
        data: @bank_users
      }
    end

    def create
      check_bank = BankUser.where(user_id: decoded_auth_token[:user_id])
      if check_bank.count == 0
        bank_user = BankUser.new
        bank_user.nama_akun       = params[:nama_akun]
        bank_user.nama_bank       = params[:nama_bank]
        bank_user.nomor_rekening  = params[:nomor_rekening]
        bank_user.user_id         = decoded_auth_token[:user_id]

        if bank_user.save
          render json: {
            success: true,
            msg: "Data bank user berhasil disimpan.",
            data: check_bank
          }
        else
          render json: {
            success: false, 
            msg:'Data bank user tidak berhasil disimpan', 
            data:bank_user.errors
          }
        end
      else
        render json: {
          success: false,
          msg: "Data bank user tidak boleh disimpan.",
        }
      end
    end

    def update
      check_bank = BankUser.where(user_id: decoded_auth_token[:user_id])
      if check_bank.count == 1
        bank_user = check_bank.first
        bank_user.nama_akun      = params[:nama_akun]
        bank_user.nama_bank      = params[:nama_bank]
        bank_user.nomor_rekening = params[:nomor_rekening]
        
        if bank_user.save
          render json: {
            success: true,
            msg: "Data bank user berhasil diubah.",
            data: check_bank
          }
        else
          render json: {
            success: false, 
            msg:'Data bank user tidak berhasil diubah', 
            data:bank_user.errors
          }
        end
      else
        render json: {
          success: false,
          msg: "Data bank user tidak tersedia.",
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