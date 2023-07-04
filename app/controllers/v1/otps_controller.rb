class V1::OtpsController < ApplicationController
  include ActionController::Cookies
  before_action :authenticate_request
  before_action :check_status_kyc

  def create

    user = User.find(decoded_auth_token[:user_id])

    otps = Otp.where(user_id: decoded_auth_token[:user_id])

    if otps.count > 0 
      render json: {
        success: false,
        msg: "Anda masih mempunyai OTP yang belum kadaluarsa. Silahkan cek email"
      }
    else  
      acak = rand(100000..1000000)

      data = Otp.new
      data.user_id = decoded_auth_token[:user_id]
      data.otp = acak
      data.save 

      # cari email user 
      TheMailer.general_mail(user.email, "Kode OTP", "Kode OTP Anda adalah: #{acak}")

      # Hapus OTP setelah 3 menit
      # https://github.com/resque/resque-scheduler
      Resque.enqueue_at(3.minutes, OtpDeleteWorker, data.id)
      
      render json: {
        success: true,
        msg: "OTP telah dikirim ke email Anda. OTP berlaku 3 menit"
      }
    end
  end
end
  