class V1::OtpsController < ApplicationController
  include ActionController::Cookies
  before_action :authenticate_request
  before_action :check_status_kyc

  def create

    user_id = decoded_auth_token[:user_id]

    puts user_id

    users = User.where(id: user_id)

    otps = Otp.where(user_id: user_id)

    if otps.count > 0 
      render json: {
        success: false,
        msg: "Anda masih mempunyai OTP yang belum kadaluarsa. Silahkan cek email"
      }
    else  
      acak = rand(100000..1000000)

      data = Otp.new
      data.user_id = user_id
      data.otp = acak
      data.save 

      puts data.to_json

      # cari email user 
      TheMailer.general_mail(users.first.email, "Kode OTP", "Kode OTP Anda adalah: #{acak}").deliver_now

      # TODO: CEK Apakah berhasil dihapus!!!!
      # Hapus OTP setelah 3 menit
      # https://github.com/resque/resque-scheduler
      Resque.enqueue_in(3.minutes, OtpDeleteWorker, data.id)
      
      render json: {
        success: true,
        msg: "OTP telah dikirim ke email Anda. OTP berlaku 3 menit"
      }
    end
  end
end
  