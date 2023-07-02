class V1::CcdepositsController < ApplicationController
  include ActionController::Cookies
  before_action :authenticate_request
  before_action :check_status_kyc


  def index
    deposits = Ccdeposit.where(user_id: decoded_auth_token[:user_id])
    render json: {
      success: true,
      msg: "Data berhasil diambil.",
      data: deposits
    }
  end


  def request_address 
    user_id = decoded_auth_token[:user_id]

    # Periksa terlebih dahulu apakah user ini sudah punya adress atau belum.
    datas = BlockEthAddr.where(user_id: user_id)

    if datas.count == 0

      # periksa apakah masih ada address yang nganggur 
      addrs = BlockEthAddr.where(user_id: 0)

      if addrs.count > 0
        addr = BlockEthAddr.where(user_id: 0).first 
        addr.user_id = user_id
        if addr.save 

          # TODO: APAKAH INI DIPERLUKAN?
          #Rails.cache.write("address_used", BlockEthAddr.where("orang_id <> 0").count)

          render json: {
            success: true,
            data: {
              user_id: user_id, 
              wallet_address: addr.address
            }
          }
        else  
          render json: {
            success: false, 
            msg:'Unknown fail', 
            }, status: :ok
        end
      else  
        # TODO: kirim email kepada nitza
        render json: {
          success: false, 
          msg:'Tidak ada address yang tersedia', 
          }, status: :ok
      end
    else  
      render json: {
        success: false, 
        msg:'Sudah punya address', 
        }, status: :ok
    end  
  end


  private
  

  def check_status_kyc
    profile = Profile.find_by_user_id(decoded_auth_token[:user_id])
    unless profile.status_kyc == "approved"
      render json: {
        success: false,
        status: 401,
        msg: "Status KYC Anda harus Approve"
      }
    end
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

    render json: {
      success: false,
      status: 401,
      msg: "Anda harus login"
    } unless @current_user
  end
end
  