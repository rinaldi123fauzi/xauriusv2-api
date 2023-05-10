module V1
    class KycController < ApplicationController
      include ActionController::Cookies
      before_action :authenticate_request

      def edit_kyc
        ActiveRecord::Base.transaction do
            @profiles = Profile.find_by_user_id(decoded_auth_token[:user_id])
            @profiles.update(full_name: params[:full_name])
            @profiles.update(phone_number: params[:phone_number])
            @profiles.update(address: params[:address])
            @profiles.update(id_number: params[:id_number])
            @profiles.update(npwp_number: params[:npwp_number])
            if params[:file_npwp].present?
                @profiles.update(file_npwp: params[:file_npwp])
            end
            if params[:file_ktp].present?
                @profiles.update(file_ktp: params[:file_ktp])
            end
        end
        render json: {success: true, message:'KYC is update', data:@profiles}, status: :ok
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