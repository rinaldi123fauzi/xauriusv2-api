# Untuk melihat token-token yang di support beserta address tokennya
class V1::EvmTokensController < ApplicationController

  def index 
    @datas = BlockEvmToken.all
    render json: {
      success: true,
      msg: "Data berhasil diambil.",
      data: @datas
    }
  end
  
end
  