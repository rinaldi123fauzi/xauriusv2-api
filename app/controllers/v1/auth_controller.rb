# notes
# https://medium.com/codex/ruby-on-rails-bcrypt-password-protection-and-user-authentication-1010a745c00c
# https://stackoverflow.com/questions/29903668/why-im-getting-undefined-method-cookies

module V1
  class AuthController < ApplicationController
    include ActionController::Cookies

    # == Keterangan
    # Digunakan untuk login
    # Pada login tipe ini, semua yang di tracking hanya orang-orang dengan login_type = 'normal'
    # Asumsi tersebut terjadi karena ada 3 tipe login dimana kemungkinan akan ada email yang sama karena dia login menggunakan sosial media lain
    # == URL
    # post /api/v1/auth/login
    # == Headers
    # -
    # == Params
    # - email
    # - password
    # == Response: JSON
    # -
    # == Todo
    def login
      @email    = params[:email].delete(' ').downcase
      @password = params[:password]
      # apple memang menyusahkan.
      # user kadang gak pakai email untuk login. Otomatis field email kosong
      # ini bisa sumber hack
      # ini harus dicegah
      if @email != ""
  
        if @password != ""
  
          @jumlah = User.where(email: @email, user_login_type: 'normal').count
          if @jumlah == 0
            app_fail_render('Silahkan mendaftar terlebih dahulu karena email ini belum terdaftar!<br>Atau mungkin jika kamu terdaftar menggunakan Facebook atau AppleID, silahkan login melalui fitur tersebut.')
          else
            @orang = User.where(email: @email, user_login_type: 'normal').first
  
            if @orang && @orang.authenticate(@password)
              if @orang.is_email_verify == true 
  
                if @orang.is_active == true
  
                  # jika user punya usaha, berikan usaha_id
                  if @orang.is_usaha == true 
                    @usaha_id = Business.where(user_id: @orang.id).first.id
                  else  
                    @usaha_id = "0"
                  end
  
                  render json: {
                    success: true,
                    msg: "Anda berhasil login.",
                    data: {
                      user: {
                        id: @orang.id,
                        user_jwt_token: create_jwt_token(@orang)
                      }
                    }
                  }
                else
                  app_fail_render('Akun Anda tidak aktif. Silahkan kontak Admin')
                end
              else  
                app_fail_render('Email belum diverifikasi. Mohon lakukan verifikasi email atau jika Anda belum dapat kode verifikasi, silahkan request.')
              end
            else
              app_fail_render('Email dan password tidak match!')
            end
          end
        else
          app_fail_render('Password wajib diisi untuk login')
        end
      else
        app_fail_render('Email wajib diisi untuk login')
      end
    end

    # == Keterangan
    # Digunakan untuk pendaftaran user
    # == URL
    # post /api/v1/auth/register
    # == Headers
    # -
    # == Params
    # - email
    # - password
    # - password_confirm
    # == Response: JSON
    # -
    # == Todo
    # 
    def register

      @email             = params[:email].delete(' ').downcase
      @password          = params[:password]
      @password_confirm  = params[:password_confirm]
  
      if @password == @password_confirm
  
        valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
        if(@email =~ valid_email_regex) == 0
          if User.where(email: @email).count == 0
  
            random_num = Random.new.rand(10000..100000)
  
            @ora               = User.new
            @ora.email         = @email
            @ora.password      = @password
            @ora.name_nick     = "u#{Random.new.rand(10000..100000)}"  # ini gak harus unik
            @ora.gender        = "male"
            @ora.phone_valid   = false
            @ora.email_vercode = random_num
            @ora.user_login_type = "normal"
            @ora.is_active = true
            if @ora.save

              # setelah selesai register, harus buat satu ID di table profile
              Profile.create!(
                {
                  user_id: @ora.id, 
                  status_kyc: 'fill'
                }
              )
  
              TheMailer.register(@ora).deliver_now
  
              render json: {
                success: true,
                msg: "Terimakasih telah mendaftar. Silahkan temukan kode verifikasi pada email Anda."
              }
            else
              if @ora.errors
                app_fail_render(@ora.errors)
              else
                app_fail_render('Terjadi kesalahan dalam penyimpanan ke database. Mohon coba 1x lagi. Jika masalah terus muncul, silahkan hubungi Admin.')
              end
            end
          else
            @orang = User.find_by(email: @email)
            if @orang.is_email_verify == true
              app_fail_render('Email terdaftar silahkan login atau coba dengan email baru')
            else
              render json: {
                success: true,
                msg: "Email belum terverifikasi, verifikasi terlebih dahulu."
              }
            end
          end
        else
          app_fail_render('Email tidak valid')
        end
      else
        app_fail_render('Password confirmation is not match')
      end
    end

    # == Keterangan
    # Ini digunakan untuk verifikasi email user berdasarkan OTP yang diinputkan
    # == URL
    # post /api/v1/auth/register_vercode
    # == Headers
    # -
    # == Params
    # +email+
    # +code+
    # == Response: JSON
    # -
    # == Todo
    # - Kirim email kepada user
    # - strong password untuk user
    # - Token atau sejenis konfirmasi ini nanti mungkin harus dimasukkan kedalam mobile app juga
    def register_vercode

      @email   = params[:email].delete(' ').downcase
      @vercode = params[:code]

      valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

      @orangs = User.where(email: @email)

      if(@email =~ valid_email_regex) == 0
        if @orangs.count == 1

          @orang = @orangs.first

          # deteksi dulu, apakah email ini sudah verified atau belum
          if @orang.is_email_verify == false || @orang.is_email_verify == nil

            # cek kode verifikasi
            if @orang.email_vercode == @vercode
              @orang.is_email_verify  = true
              if @orang.save
                
                render json: {
                  success: true,
                  msg: 'Selamat, Anda berhasil mendaftar.',
                  data: {
                    orang: {
                      id: @orang.id,
                      user_jwt_token: create_jwt_token(@orang)
                    }
                  }
                }

              else
                if @orang.errors
                  app_fail_render(@ora.errors)
                else
                  app_fail_render('Terjadi kesalahan dalam penyimpanan ke database. Mohon coba 1x lagi. Jika masalah terus muncul, silahkan hubungi Admin.')
                end
              end
            else
              app_fail_render('Kode verifikasi salah')
            end
          else
            app_fail_render('Email sudah diverifikasi. Silahkan login atau kirim permintaan lupa password jika lupa password.')
          end
        else
          app_fail_render('Email tidak ditemukan')
        end
      else
        app_fail_render('Email tidak valid')
      end
    end

    # == Keterangan
    # Digunakan untuk permintaan ulang email verifikasi
    # == URL
    # post /api/v1/auth/email_verification_token_request
    # == Headers
    # -
    # == Params
    # +email+
    # == Response: JSON
    # -
    # == Todo
    # - Kirim email kepada user
    def email_verification_token_request
      @email = params[:email].delete(" ").downcase

      @orang = User.where(email: @email).first

      if @orang
        if @orang.is_email_verify == true
          app_fail_render("Email already verified. Please log in or request a password reset instruction if you forgot your password")
        else
          random_num = Random.new.rand(10000..100000)

          @orang.email_vercode = random_num
          @orang.save

          TheMailer.register(@orang).deliver_later

          render json: {
            success: true,
            msg: 'Kode verifikasi telah dikirimkan ke email Anda. Silahkan diisikan pada saat verifikasi email.',
            data: {}
          }
        end
      else
        app_fail_render("Email not found")
      end
    end

    # == Keterangan
    # Digunakan untuk mengirimkan email berupa link atau token kepada user yang meminta lupa password
    # == URL
    # post /api/v1/auth/forgot_password
    # Headers
    # -
    # == Params
    # +email+
    # == Todo
    # - Kirim email kepada user tentang reset tokennya
    # - App type 
    # - link yang dikirim ke email harus disempurnakan (web)
    # - Token expire!
    def forgot_password
      @email    = params[:email]
      @app_type = params[:app_type]

      @count = User.where(email: @email).count

      if @count == 0
        app_fail_render('Silahkan mendaftar terlebih dahulu karena email ini belum terdaftar!')
      else

        # jika lewat mobile, metodenya lain
        if @app_type == 'mobile'
          @random_number = Random.new.rand(10000..100000)
        else  
          @random_number = SecureRandom.hex(13)
        end

        # cari orang
        @orang = User.where(email: @email).first
        @orang.pass_reset_token = @random_number
        @orang.save

        # kirim email
        the_domain = "#{request.protocol}#{request.host_with_port}" # http://namadomain.com:port
        TheMailer.forgot_password_link(@orang, the_domain, @app_type).deliver_now

        render json: {
          success: true,
          msg: 'Instruksi pengantian password terikirim ke email Anda. Jika tidak terlihat di inbox, mohon diperiksa di spam box',
          data: {
            email: @email
          }
        }
      end
    end

    # == Keterangan
    # Digunakan untuk membuat token supaya password bisa di reset
    # == URL
    # post /api/v1/auth/change_password
    # == Headers
    # -
    # == Params
    # +email+
    # +token+
    # +password+
    # +password_confirm+
    # == Response: JSON
    # -
    # == Todo
    #
    def change_password
      @email            = params[:email]
      @token            = params[:token]
      @password         = params[:password]
      @password_confirm = params[:password_confirm]

      if @password == @password_confirm

        @jumlah = User.where(email: @email, pass_reset_token: @token).count

        if @jumlah == 0
          app_fail_render('Kombinasi email dan token tidak benar')
        else
          @orang = User.where(email: @email, pass_reset_token: @token).first
          @orang.password         = @password
          @orang.pass_reset_token = 0
          if @orang.save
            render json: {
              success: true,
              msg: 'Password berhasil diganti. Silahkan masuk dengan password yang baru.',
              data: {
                email: @email
              }
            }
          else
            app_fail_render('Kesalah server. Mohon dicoba kembali.')
          end
        end
      else
        app_fail_render('Password dan konfirmasi password tidak sama')
      end
    end

    def destroy
      if cookies[:JWT].present? 
        @decode = JsonWebToken.decode(cookies[:JWT])
        User.update(@decode[:user_id], {session_id: 0})
        cookies[:JWT] = ""
        render json: {
          success: true, 
          msg:'logout success', 
          }, status: :ok
      else
        render json: {
          success: false , 
          msg:'logout gagal', 
          }, status: :ok
      end
    end

    def app_fail_render(msg)
      render json: {
        success: false,
        msg: msg
      }
    end

    private 
    def create_jwt_token(user_obj)

      # @tokenbig = Digest::SHA1.hexdigest(user_.id.to_s + "_" + self.user_email)
      # self.update_column(:user_tokenbig, @tokenbig)

      #MODIFIKASI
      @rand = rand(1111..9999)

      payload = {:email => user_obj.email, :user_id => user_obj.id, :session_id => @rand}
      token = JsonWebToken.encode(payload)
      user_obj.update_column(:jwt_token, token)
      user_obj.update_column(:session_id, @rand)

      #ORIGINAL
      # hmac_secret = "Ini Password"
  
      # payload = {:email => user_obj.email, :id => user_obj.id}
      # token = JWT.encode(payload, hmac_secret, 'HS256')
      # user_obj.update_column(:jwt_token, token)
  
      return token
    end
  end
end
  