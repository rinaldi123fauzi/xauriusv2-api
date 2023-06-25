class V1::BankController < ApplicationController
  def index
    banks = Bank.all
    render json: {
      success: true,
      msg: "Data barhasil diambil.",
      data: banks
    }
  end
end
    