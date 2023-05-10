module V1
  class DepositsController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      deposits = Deposit.where(user_id: decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: deposits
      }
    end

    def show
      deposits = Deposit.find_by_user_id(decoded_auth_token[:user_id])
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: deposits
      }
    end

    def create
      @deposits = Deposit.new
      @deposits.name_bank = params[:name_bank]
      @deposits.unit_price = params[:unit_price]
      @deposits.quantity = params[:quantity]
      @deposits.total = params[:total]
      @deposits.date = params[:date]
      @deposits.order = params[:order]
      @deposits.user_id = params[:user_id]
      if @deposits.save
        @checkBalances = Balance.find_by_user_id(decoded_auth_token[:user_id])
        if @checkBalances
          @checkBalances.update(balance_value: params[:total])          
          @checkBalances.update(currency: params[:currency])
        else
          @balance = Balance.new
          @balance.balance_value = params[:total]          
          @balance.currency = params[:currency]          
        end
        render json: {success: true, message:'Deposits is saved', data:@deposits}, status: :ok
      else
        render json: {success: false, message:'Deposits is not saved', data:@deposits.errors}, status: :unprocessable_entity
      end
    end

    def update
      deposits = Deposit.find_by_user_id(decoded_auth_token[:user_id])
      deposits.update(name_bank: params[:name_bank])
      deposits.update(unit_price: params[:unit_price])
      deposits.update(quantity: params[:quantity])
      deposits.update(total: params[:total])
      deposits.update(date: params[:date])
      deposits.update(order: params[:order])
      deposits.update(user_id: params[:user_id])

      @checkBalances = Balance.find_by_user_id(decoded_auth_token[:user_id])
      @checkBalances.update(balance_value: params[:total])          
      @checkBalances.update(currency: params[:currency])
      render json: {success: true, message:'Deposit is update', data:deposits}, status: :ok
    end

    def destroy
      deposits = Deposit.find_by_user_id(decoded_auth_token[:user_id])
      deposits.destroy!
      render json: {success: true, message:'Deposit has been deleted', data:deposits}, status: :ok
    end

    private
    def deposit_params
      params.require(:deposit).permit(:name_bank,:unit_price,:quantity,:total,:date,:order, :user_id)
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
  