module V1
  class WithdrawsController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      withdraws = Withdraw.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: withdraws
      }
    end
    def show
      withdraws = Withdraw.find(params[:id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: withdraws
      }
    end
    def create
      @withdraws = Withdraw.new
      @withdraws.name_bank = params[:name_bank]
      @withdraws.account_number = params[:account_number]
      @withdraws.cash_balance = params[:cash_balance]
      @withdraws.ammount = params[:ammount]
      @withdraws.date = params[:date]
      @withdraws.withdraw = params[:withdraw]
      @withdraws.status = params[:status]
      @withdraws.user_id = params[:user_id]
      if @withdraws.save
        render json: {success: true, message:'Withdraws is saved', data:@withdraws}, status: :ok
      else
        render json: {success: false, message:'Withdraws is not saved', data:@withdraws.errors}, status: :unprocessable_entity
      end
    end
    def update
      @withdraws = Withdraw.find(params[:id])
      @withdraws.update(name_bank: params[:name_bank])
      @withdraws.update(account_number: params[:account_number])
      @withdraws.update(cash_balance: params[:cash_balance])
      @withdraws.update(ammount: params[:ammount])
      @withdraws.update(date: params[:date])
      @withdraws.update(withdraw: params[:withdraw])
      @withdraws.update(status: params[:status])
      @withdraws.update(user_id: params[:user_id])
      render json: {success: true, message:'Withdraw is update', data:@withdraws}, status: :ok
    end
    def destroy
      withdraws = Withdraw.find(params[:id])
      withdraws.destroy!
      render json: {success: true, message:'Withdraw has been deleted', data:withdraws}, status: :ok
    end

    private
    def withdraw_params
      params.require(:withdraw).permit(:name_bank,:account_number,:cash_balance,:ammount,:date,:withdraw,:status,:user_id)
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
  