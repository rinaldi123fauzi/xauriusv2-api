module V1
  class DepositsController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request
    before_action :check_status_kyc

    def index
      deposits = Deposit.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: ActiveModelSerializers::SerializableResource.new(deposits, each_serializer: DepositSerializer)
      }
    end

    def show
      deposits = Deposit.where(id: params[:id], user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: ActiveModelSerializers::SerializableResource.new(deposits, each_serializer: DepositSerializer)
      }
    end

    def uploadDeposit
      @id = params[:id]
      @file_deposit = params[:file_deposit]

      if @file_deposit != nil && @file_deposit != ""

        @deposits = Deposit.where(id: @id, user_id: decoded_auth_token[:user_id], status: 'create')

        if @deposits.count == 1
          @deposit = @deposits.first

          @deposit.file_deposit = @file_deposit
          @deposit.status       = "file-upload" 
          if @deposit.save
            render json: {
              success: true, 
              msg:'Deposits is saved', 
              data: ActiveModelSerializers::SerializableResource.new(@deposit, each_serializer: DepositSerializer)}, status: :ok
          else
            render json: {success: false, msg:'Deposits is not saved', data:@deposit.errors}, status: :unprocessable_entity
          end
        else  
          render json: {success: false, msg:'Data dengan status create tidak ditemukan'}, status: :unprocessable_entity
        end
      else  
        render json: {success: false, msg:'Anda tidak mengupload file'}, status: :unprocessable_entity
      end
    end

    def create
      @deposits = Deposit.new
      @deposits.bank_id = params[:bank_id]
      @deposits.total     = params[:total]
      @deposits.user_id   = decoded_auth_token[:user_id]
      @deposits.status    = "create"
      if @deposits.save
        render json: {
          success: true, 
          msg:'Deposits is saved', 
          data: ActiveModelSerializers::SerializableResource.new(@deposits, each_serializer: DepositSerializer)}, status: :ok
      else
        render json: {success: false, msg:'Deposits is not saved', data:@deposits.errors}, status: :unprocessable_entity
      end
    end

    private
    def deposit_params
      params.require(:deposit).permit(:name_bank,:unit_price,:quantity,:total,:date,:order, :user_id)
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
      } unless @current_user
    end

  end
end
  