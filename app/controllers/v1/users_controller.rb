module V1
  class UsersController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      users = User.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: users
      }
    end
    def show
      users = User.find(params[:id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: users
      }
    end
    def create
      @users = User.new
      @users.username = params[:username]
      @users.password = params[:password]
      @users.name = params[:name]
      @users.email = params[:email]
      @users.is_active = params[:is_active]
      @users.is_email_verify = params[:is_email_verify]
      @users.is_usaha = params[:is_usaha]
      if @users.save
        render json: {success: true, message:'User is saved', data:@users}, status: :ok
      else
        render json: {success: false, message:'User is not saved', data:@users.errors}, status: :unprocessable_entity
      end
    end
    def update
      @users = User.find(params[:id])
      @users.update(username: params[:username])
      @users.update(password: params[:password])
      @users.update(name: params[:name])
      @users.update(email: params[:email])
      @users.update(is_active: params[:is_active])
      @users.update(is_email_verify: params[:is_email_verify])
      @users.update(is_usaha: params[:is_usaha])
      render json: {success: true, message:'Users is update', data:@users}, status: :ok
    end
    def destroy
      users = User.find(params[:id])
      users.destroy!
      render json: {success: true, message:'Users has been deleted', data:users}, status: :ok
    end

    private
    def profile_params
      params.require(:user).permit(:username,:password,:name,:email,:is_active,:is_email_verify,:is_usaha)
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
  