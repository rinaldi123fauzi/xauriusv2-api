class V1::ProfilesController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request
    # before_action :check_status_kyc

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

      @checkProfile = Profile.where(user_id: user_id)

      # jika user tidak ditemukan
      if @checkProfile.count == 0
        @profile.full_name     = params[:full_name] if params[:full_name] && params[:full_name] != ""

        # TODO gem phonelib
        @profile.phone_number  = params[:phone_number] if params[:phone_number] && params[:phone_number] != ""
        
        @profile.address       = params[:address] if params[:address] && params[:address] != ""
        @profile.id_number     = params[:id_number] if params[:id_number] && params[:id_number] != ""
        @profile.npwp_number   = params[:npwp_number] if params[:npwp_number] && params[:npwp_number] != ""
        @profile.country       = params[:country] if params[:country] && params[:country] != ""
        @profile.user_id       = user_id

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
              success: false,
              msg: @profile.errors.to_json
            }
          else  
            render json: {
              success: false,
              msg: 'Unknown error'
            }
          end
        end

      # jika user ditemukan diprofile
      else
        @profile = Profile.find_by_user_id(user_id)

        if @profile.status_kyc == false 

          @profile.full_name     = params[:full_name] if params[:full_name] && params[:full_name] != ""
          @profile.phone_number  = params[:phone_number] if params[:phone_number] && params[:phone_number] != ""
          @profile.address       = params[:address] if params[:address] && params[:address] != ""
          @profile.id_number     = params[:id_number] if params[:id_number] && params[:id_number] != ""
          @profile.npwp_number   = params[:npwp_number] if params[:npwp_number] && params[:npwp_number] != ""
          @profile.country       = params[:country] if params[:country] && params[:country] != ""

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
                success: false,
                msg: @profile.errors.to_json
              }
            else  
              render json: {
                success: false,
                msg: 'Unknown error'
              }
            end
          end
        else 
          render json: {
            success: false,
            msg: 'KYC tidak boleh di edit'
          }
        end
      end
    end

    def evm_address 
      user_id = decoded_auth_token[:user_id]

      @profile = Profile.find_by_user_id(user_id)

      if @profile.status_kyc == true

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

        # query 1x lagi dan pasti sudah ada address 
        data = BlockEthAddr.where(user_id: user_id).first 

        render json: {
          success: true,
          data: data.address
        }
      else  
        app_fail_render("KYC belum disetujui")
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

    def check_status_kyc
      profile = Profile.find_by_user_id(decoded_auth_token[:user_id])
      if profile.status_kyc == false
        render json: { error: 'Anda Harus KYC Terlebihdahulu' }, status: 401
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
  