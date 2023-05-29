class V1::ChartsController < ApplicationController

  def index
    charts = Chart.all
    render json: {
      success: true,
      msg: "Data barhasil diambil.",
      data: charts
    }
  end

  def last_price
    @current_gold_price = Chartprice.where(chartprice_exchange: "app_price").last

    render json: {
      status: 'success',
      data: {
        price: @current_gold_price.chartprice_price,
        buy: @current_gold_price.chartprice_buy,
        sell: @current_gold_price.chartprice_sell
      }
    }
  end


end
  