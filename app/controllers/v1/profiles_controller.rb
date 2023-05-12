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

    # def create
    #   ActiveRecord::Base.transaction do
    #     @profiles = Profile.new
    #     @profiles.full_name = params[:full_name]
    #     @profiles.phone_number = params[:phone_number]
    #     @profiles.address = params[:address]
    #     @profiles.id_number = params[:id_number]
    #     @profiles.npwp_number = params[:npwp_number]
    #     @profiles.user_id = params[:user_id]
    #     @profiles.file_npwp = params[:file_npwp]
    #     @profiles.file_ktp = params[:file_ktp]
    #     if @profiles.save
    #       render json: {success: true, message:'Profiles is saved', data:@profiles}, status: :ok
    #     else
    #       render json: {success: false, message:'Profiles is not saved', data:@profiles.errors}, status: :unprocessable_entity
    #     end
    #   end
    # end

    def update
      ActiveRecord::Base.transaction do
        @profiles = Profile.find_by_user_id(decoded_auth_token[:user_id])
        @profiles.update(full_name: params[:full_name])
        @profiles.update(phone_number: params[:phone_number])
        @profiles.update(address: params[:address])
        @profiles.update(id_number: params[:id_number])
        @profiles.update(npwp_number: params[:npwp_number])
        @profiles.update(country: params[:country])
        if params[:file_npwp]
          @profiles.update(file_npwp: params[:file_npwp])
        end
        if params[:file_ktp]
          @profiles.update(file_ktp: params[:file_ktp])
        end
        if params[:image]
          @profiles.update(image: params[:image])
        end
      end
      render json: {success: true, message:'Profiles is update', data:@profiles}, status: :ok
    end

    # def destroy
    #   profiles = Profile.find_by_user_id(decoded_auth_token[:user_id])
    #   profiles.destroy!
    #   render json: {success: true, message:'Profiles has been deleted', data:profiles}, status: :ok
    # end

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
  