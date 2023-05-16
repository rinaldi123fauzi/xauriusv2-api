module V1
  class WithdrawsController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      withdraws = Withdraw.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: withdraws
      }
    end

    def show
      withdraws = Withdraw.find_by_user_id(decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: withdraws
      }
    end

    def create
      @checkBalances = Balance.find_by_user_id(decoded_auth_token[:user_id])

      @withdraws = Withdraw.new
      @withdraws.name_bank = params[:name_bank]
      @withdraws.account_number = params[:account_number]
      @withdraws.cash_balance = params[:cash_balance]
      @withdraws.ammount = params[:ammount]
      @withdraws.date = params[:date]
      @withdraws.withdraw = params[:withdraw]
      @withdraws.status = params[:status]
      @withdraws.user_id = decoded_auth_token[:user_id]

      if @checkBalances.balance_value >= params[:withdraw]
        if @withdraws.save
          @sum = @checkBalances.balance_value - params[:withdraw]
          @checkBalances.update(balance_value: @sum)          
          @checkBalances.update(currency: params[:currency])
          render json: {success: true, msg:'Withdraws is saved', data:@withdraws}, status: :ok
        else
          render json: {success: false, msg:'Withdraws is not saved', data:@withdraws.errors}, status: :unprocessable_entity
        end
      else
        render json: {
          success: false, 
          msg:'Balances tidak mencukupi'
          }, status: :ok
      end
    end

    def update
      @withdraws = Withdraw.find_by_user_id(decoded_auth_token[:user_id])
      @withdraws.name_bank = params[:name_bank]
      @withdraws.account_number = params[:account_number]
      @withdraws.cash_balance = params[:cash_balance]
      @withdraws.ammount = params[:ammount]
      @withdraws.date = params[:date]
      @withdraws.withdraw = params[:withdraw]
      @withdraws.status = params[:status]
      @withdraws.user_id = params[:user_id]
      
      if @withdraws.save
        render json: {success: true, msg:'Withdraw is update', data:@withdraws}, status: :ok
      else
        render json: {success: false, msg:'Withdraw is not update', data:@withdraws.errors}, status: :ok
      end
    end

    def destroy
      withdraws = Withdraw.find_by_user_id(decoded_auth_token[:user_id])
      withdraws.destroy!
      render json: {success: true, msg:'Withdraw has been deleted', data:withdraws}, status: :ok
    end

    private
    def withdraw_params
      params.require(:withdraw).permit(:name_bank,:account_number,:cash_balance,:ammount,:date,:withdraw,:status,:user_id)
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
  