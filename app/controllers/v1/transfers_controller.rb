module V1
  class TransfersController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      transfers = Transfer.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: transfers
      }
    end
    def show
      transfers = Transfer.find(params[:id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: transfers
      }
    end
    def create
      @transfers = Transfer.new
      @transfers.network = params[:network]
      @transfers.address_wallet = params[:address_wallet]
      @transfers.date = params[:date]
      @transfers.tx_hash = params[:tx_hash]
      @transfers.address = params[:address]
      @transfers.quantity = params[:quantity]
      @transfers.status = params[:status]
      @transfers.user_id = params[:user_id]
      if @transfers.save
        render json: {success: true, message:'Transfers is saved', data:@transfers}, status: :ok
      else
        render json: {success: false, message:'Transfers is not saved', data:@transfers.errors}, status: :unprocessable_entity
      end
    end
    def update
      @transfers = Transfer.find(params[:id])
      @transfers.update(network: params[:network])
      @transfers.update(address_wallet: params[:address_wallet])
      @transfers.update(date: params[:date])
      @transfers.update(tx_hash: params[:tx_hash])
      @transfers.update(address: params[:address])
      @transfers.update(quantity: params[:quantity])
      @transfers.update(status: params[:status])
      render json: {success: true, message:'Transfers is update', data:@transfers}, status: :ok
    end
    def destroy
      transfers = Transfer.find(params[:id])
      transfers.destroy!
      render json: {success: true, message:'Transfers has been deleted', data:transfers}, status: :ok
    end

    private
    def transfer_params
      params.require(:transfer).permit(:network,:address_wallet,:date,:tx_hash,:address,:quantity,:status,:user_id)
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
  