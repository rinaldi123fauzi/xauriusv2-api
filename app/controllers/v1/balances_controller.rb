module V1
  class BalancesController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request
    before_action :check_status_kyc

    def index
      @balances = Balance.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data berhasil diambil.",
        data: @balances
      }
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
        }, status: 401
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
  end
end