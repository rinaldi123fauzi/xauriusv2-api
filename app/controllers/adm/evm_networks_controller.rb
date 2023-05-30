module Adm
  class EvmNetworksController < ApplicationController
    include ActionController::Cookies
    # before_action :authenticate_request

    def index
      evm_network = EvmNetwork.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: evm_network
      }
    end

    def show
      evm_network = EvmNetwork.find(params[:evm_network_id])
      render json: {
        success: true,
        msg: "Data detail barhasil diambil.",
        data: evm_network
      }
    end

    def create
      @evm_network = EvmNetwork.new
      @evm_network.network_name     = params[:network_name]
      @evm_network.rpc_url          = params[:rpc_url]
      @evm_network.chain_id         = params[:chain_id]
      @evm_network.currency_symbol  = params[:currency_symbol]
      @evm_network.explorer         = params[:explorer]
      
      if @evm_network.save
        render json: {
          success: true, 
          msg:'evm_network is saved', 
          data:{
            evm_network: @evm_network,
            balance: balance
          }
        }, status: :ok
      else
        render json: {success: false, msg:'Evm Network is not saved', data:@evm_network.errors}, status: :unprocessable_entity
      end
    end

    def update
      @evm_network = EvmNetwork.find(params[:evm_network_id])
      @evm_network.network_name     = params[:network_name]
      @evm_network.rpc_url          = params[:rpc_url]
      @evm_network.chain_id         = params[:chain_id]
      @evm_network.currency_symbol  = params[:currency_symbol]
      @evm_network.explorer         = params[:explorer]
      
      if @evm_network.save
        render json: {
          success: true, 
          msg:'evm_network is saved', 
          data:{
            evm_network: @evm_network,
            balance: balance
          }
        }, status: :ok
      else
        render json: {success: false, msg:'Evm Network is not saved', data:@evm_network.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      evm_network = EvmNetwork.find(params[:evm_network_id])
      evm_network.destroy!
      render json: {success: true, msg:'Evm Network has been deleted', data:evm_network}, status: :ok
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
        @current_user = AuthAdminRequest.call(request.headers["JWT"]).result
      else
        @current_user = AuthAdminRequest.call(cookies[:JWT]).result
      end
  
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end

  end
end
      