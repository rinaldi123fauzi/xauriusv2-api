class V1::ProfilesController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      @profile = Profile.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data berhasil diambil.",
        data: ActiveModelSerializers::SerializableResource.new(@profile, each_serializer: ProfileSerializer)
      }
    end

    def show
      @profile = Profile.find_by_user_id(decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data detail berhasil diambil.",
        data: ActiveModelSerializers::SerializableResource.new(@profile, each_serializer: ProfileSerializer)
      }
    end

    def update

      user_id = decoded_auth_token[:user_id]

      @checkProfile = Profile.where('user_id = ? and status_kyc = ? or status_kyc = ?', user_id, 'fill', 'rejected')

      # jika memenuhi status fill atau rejected
      if @checkProfile.count == 1
        @profile = @checkProfile.first
        @profile.full_name     = params[:full_name] if params[:full_name] && params[:full_name] != ""
        @profile.phone_number  = params[:phone_number] if params[:phone_number] && params[:phone_number] != ""
        @profile.address       = params[:address] if params[:address] && params[:address] != ""
        @profile.id_number     = params[:id_number] if params[:id_number] && params[:id_number] != ""
        @profile.npwp_number   = params[:npwp_number] if params[:npwp_number] && params[:npwp_number] != ""
        @profile.country       = params[:country] if params[:country] && params[:country] != ""
        @profile.status_kyc    = "review"

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
            msg: 'Mohon tunggu KYC Anda sedang kami review.', 
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
        profile = Profile.where(user_id: user_id, status_kyc: 'approved')
        if profile.count == 1
          render json: {
            success: false,
            msg: 'Maaf, Anda tidak dapat mengubah data diri.'
          }
        else
          render json: {
            success: false,
            msg: 'Maaf, Anda tidak dapat mengubah data diri karena telah mengirimkan data KYC sebelumnya. Mohon menunggu update dari kami.'
          }
        end
      end
    end

    def evm_address 
      user_id = decoded_auth_token[:user_id]

      @profile = Profile.find_by_user_id(user_id)

      if @profile.status_kyc == "approved"

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
  