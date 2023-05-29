module Adm
  class UsersController < ApplicationController
    include ActionController::Cookies
    # before_action :authenticate_request

    def index
      users = User.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: users
      }
    end

    def show
      users = User.find(params[:user_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: users
      }
    end

    def create
      @users = User.new
      @users.username         = params[:username]
      @users.password         = params[:password]
      @users.name             = params[:name]
      @users.email            = params[:email]
      @users.is_active        = params[:is_active]
      @users.is_email_verify  = params[:is_email_verify]
      @users.is_usaha         = params[:is_usaha]
      
      if @users.save
        render json: {success: true, msg:'Users is create', data:@users}, status: :ok
      else
        render json: {success: false, msg:'Users is not create', data:@users.errors}, status: :ok
      end
    end

    def update
      @users = User.find(params[:user_id])
      @users.username         = params[:username]
      @users.password         = params[:password]
      @users.name             = params[:name]
      @users.email            = params[:email]
      @users.is_active        = params[:is_active]
      @users.is_email_verify  = params[:is_email_verify]
      @users.is_usaha         = params[:is_usaha]
      if @users.save
        render json: {success: true, msg:'Users is update', data:@users}, status: :ok
      else
        render json: {success: false, msg:'Users is not update', data:@users.errors}, status: :ok
      end
    end

    def destroy
      users = User.find(params[:user_id])
      users.destroy!
      render json: {success: true, msg:'Users has been deleted', data:users}, status: :ok
    end

    private
    def profile_params
      params.require(:user).permit(:username,:password,:name,:email,:is_active,:is_email_verify,:is_usaha)
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
    