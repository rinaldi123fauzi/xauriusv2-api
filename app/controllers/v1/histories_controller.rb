module V1
  class HistoriesController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      datas = History.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data berhasil diambil.",
        data: ActiveModelSerializers::SerializableResource.new(datas, each_serializer: HistorySerializer)
      }
    end

    def show
      data = History.where(id: params[:id], user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data detail berhasil diambil.",
        data: ActiveModelSerializers::SerializableResource.new(data, each_serializer: HistorySerializer)
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
  