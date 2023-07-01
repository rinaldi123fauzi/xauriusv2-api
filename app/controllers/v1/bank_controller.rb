class V1::BankController < ApplicationController
  def index
    banks = Bank.all
    render json: {
      success: true,
      msg: "Data berhasil diambil.",
      data: banks
    }
  end
end
    