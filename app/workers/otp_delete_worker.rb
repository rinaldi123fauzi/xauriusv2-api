class OtpDeleteWorker
  @queue = :del_opt

  def self.perform(otp_id)
    Otp.where(id: otp_id).destroy_all
  end
end
