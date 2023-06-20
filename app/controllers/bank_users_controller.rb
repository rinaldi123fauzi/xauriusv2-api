class BankUsersController < ApplicationController
  before_action :set_bank_user, only: %i[ show update destroy ]

  # GET /bank_users
  # GET /bank_users.json
  def index
    @bank_users = BankUser.all
  end

  # GET /bank_users/1
  # GET /bank_users/1.json
  def show
  end

  # POST /bank_users
  # POST /bank_users.json
  def create
    @bank_user = BankUser.new(bank_user_params)

    if @bank_user.save
      render :show, status: :created, location: @bank_user
    else
      render json: @bank_user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bank_users/1
  # PATCH/PUT /bank_users/1.json
  def update
    if @bank_user.update(bank_user_params)
      render :show, status: :ok, location: @bank_user
    else
      render json: @bank_user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bank_users/1
  # DELETE /bank_users/1.json
  def destroy
    @bank_user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_user
      @bank_user = BankUser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bank_user_params
      params.require(:bank_user).permit(:user_id, :nama_akun, :nama_bank, :nomor_rekening, :status)
    end
end
