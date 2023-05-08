module V1
  class BuysController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request

    def index
      buys = Buy.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: buys
      }
    end
    def show
      buys = Buy.find(params[:id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: buys
      }
    end
    def create
      @buys = Buy.new
      @buys.spend = params[:spend]
      @buys.summary = params[:summary]
      @buys.date = params[:date]
      @buys.price = params[:price]
      @buys.quantity = params[:quantity]
      @buys.status = params[:status]
      @buys.user_id = params[:user_id]
      if @buys.save
        render json: {success: true, message:'Buys is saved', data:@buys}, status: :ok
      else
        render json: {success: false, message:'Buys is not saved', data:@buys.errors}, status: :unprocessable_entity
      end
    end
    def update
      @buys = Buy.find(params[:id])
      @buys.update(spend: params[:spend])
      @buys.update(summary: params[:summary])
      @buys.update(date: params[:date])
      @buys.update(price: params[:price])
      @buys.update(quantity: params[:quantity])
      @buys.update(status: params[:status])
      @buys.update(user_id: params[:user_id])
      render json: {success: true, message:'Buys is update', data:@buys}, status: :ok
    end
    def destroy
      buys = Buy.find(params[:id])
      buys.destroy!
      render json: {success: true, message:'Buys has been deleted', data:buys}, status: :ok
    end

    private
    def buy_params
      params.require(:buy).permit(:spend,:summary,:date,:price,:quantity,:status,:user_id)
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
  