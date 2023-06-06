module V1
  class EvmNetworksController < ApplicationController
    def index
      @evm_network = EvmNetwork.all
      render json: {
        success: true,
        msg: "Data barhasil diambil.",
        data: @evm_network
      }
    end
  end
end