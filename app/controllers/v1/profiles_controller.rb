module V1
  class ProfilesController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      profiles = Profile.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: profiles.as_json(include: :image)
      }
    end

    def show
      profiles = Profile.find_by_user_id(decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: profiles
      }
    end

    
    def update

      @profile = Profile.find_by_user_id(decoded_auth_token[:user_id])
      @profile.full_name     = params[:full_name]
      @profile.phone_number  = params[:phone_number]
      @profile.address       = params[:address]
      @profile.id_number     = params[:id_number]
      @profile.npwp_number   = params[:npwp_number]
      @profile.country       = params[:country]

      if params[:file_npwp] && params[:file_npwp] != ""
        @profile.file_npwp = params[:file_npwp]
      end

      if params[:file_ktp] && params[:file_ktp] != ""
        @profile.file_ktp = params[:file_ktp]
      end

      if params[:image] && params[:image] != ""
        @profile.image = params[:image]
      end

      @profile.save

      render json: {success: true, message:'Profiles is update', data:@profiles}, status: :ok
    end

  
    private
    def profile_params
      params.require(:profile).permit(:full_name,:phone_number,:address,:id_number,:npwp_number,:deposit,:user_id)
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
  