module V1
  class ProfilesController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      @profile = Profile.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: ActiveModelSerializers::SerializableResource.new(@profile, each_serializer: ProfileSerializer)
      }
    end

    def show
      @profile = Profile.find_by_user_id(decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: ActiveModelSerializers::SerializableResource.new(@profile, each_serializer: ProfileSerializer)
      }
    end

    def update

      user_id = decoded_auth_token[:user_id]

      @profile = Profile.find_by_user_id(user_id)

      if @profile.status_kyc == false 

        @profile.full_name     = params[:full_name] if params[:full_name] && params[:full_name] != ""
        @profile.phone_number  = params[:phone_number] if params[:phone_number] && params params[:phone_number] != ""
        @profile.address       = params[:address] if params[:address] && params params[:address] != ""
        @profile.id_number     = params[:id_number] if params[:id_number] && params params[:id_number] != ""
        @profile.npwp_number   = params[:npwp_number] if params[:npwp_number] && params params[:npwp_number] != ""
        @profile.country       = params[:country] if params[:country] && params params[:country] != ""

        if params[:file_npwp] && params[:file_npwp] != ""
          @profile.file_npwp = params[:file_npwp]
        end

        if params[:file_ktp] && params[:file_ktp] != ""
          @profile.file_ktp = params[:file_ktp]
        end

        if params[:image] && params[:image] != ""
          @profile.image = params[:image]
        end

        if @profile.save

          render json: {
            success: true, 
            msg: 'Profiles is update', 
            data: ActiveModelSerializers::SerializableResource.new(@profile, each_serializer: ProfileSerializer)
          }, status: :ok
        else 
          if @profile.errors
            render json: {
              status: false,
              msg: @profile.errors.to_json
            }
          else  
            render json: {
              status: false,
              msg: 'Unknown error'
            }
          end
        end
      else 
        render json: {
          status: false,
          msg: 'KYC tidak boleh di edit'
        }
      end
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
  