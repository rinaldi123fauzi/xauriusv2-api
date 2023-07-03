class V1::OtpsController < ApplicationController
  include ActionController::Cookies
  before_action :authenticate_request
  before_action :check_status_kyc

  def create
    otps = Otp.where(user_id: decoded_auth_token[:user_id])

    if otps.count > 0 

    else  
      acak = rand(100000..1000000)

      Otp.create({
        user_id: decoded_auth_token[:user_id],
        otp: acak
      })

      # TODO: kirim email OTP 


      # Hapus OTP setelah 3 menit
      


      render json: {
        success: true,
        msg: "OTP telah dikirim ke email Anda. OTP berlaku 3 menit"
      }
    end
  end
end
  