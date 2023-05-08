class TheMailer < ApplicationMailer

    def register(orang_obj)
      @orang = orang_obj
      @klik_link = "#{ENV["DOMAIN_WEB"]}/v1/auth/email-verification?email=#{@orang.email}&code=#{@orang.email_vercode}"
      mail(to: @orang.email, subject: "Kode verifikasi email untuk pendaftaran")
    end
  
    def general_mail(email, subject, content)
      @content = content
      mail(to: email, subject: subject)
    end
  
    # = Keterangan
    # Digunakan untuk mengirimkan link reset password
    # == Params
    # +user+ : Objek user
    # == Todo
    # -
    def forgot_password_link(user_obj, the_domain, app_type)
      @user = user_obj
      @link = "#{ENV["APP_DOMAIN_WEB"]}/v1/auth/change-password?email=#{@user.email}&token=#{@user.pass_reset_token}"
      @app_type = app_type
      mail(to: @user.email, subject: 'Instruksi reset password')
    end
  
end