class WithdrawGeneralService < ApplicationService
  attr_accessor :session_orang_id, :simbol, :amount, :withdraw_to, 
    :otp, :google_secret, :wd_fee, :chain_id, :contract_address

  def initialize(session_orang_id, simbol, amount, withdraw_to, 
    otp, google_secret, wd_fee, chain_id, contract_address)
    
    @session_orang_id = session_orang_id 
    @simbol = simbol 
    @amount = amount 
    @withdraw_to = withdraw_to 
    @otp = otp 
    @google_secret = google_secret
    @wd_fee = wd_fee
    @chain_id = chain_id
    @contract_address = contract_address

  end

  def call
    @amount = amount.to_f

    orang_obj = User.find(@session_orang_id)

    if !@otp.nil?
      @otp = @otp.to_i

      # cek otp
      otp_objs = Otp.where(user_id: @session_orang_id)

      if otp_objs.count > 0
        otp_obj = otp_objs.first 

        if otp_obj.otp == @otp 

          # Hapus otp yang lama
          otp_obj.destroy 
    
          # TODO: TESTING KARENA PEMANGGILAN DISINI SEPERTINYA SALAH
          ccurrency_withdraw
        else  
          {
            success: false,
            message: "Otp salah"
          }  
        end
      else  
        {
          success: false,
          message: "Otp tidak ditemukan"
        }
      end
    elsif !google_secret.nil?
      # if orang_obj.google_authentic?(google_secret)

      #   # TODO: Coba cek ini.... kenapa harus di update google secretnya?????
      #   # orang_obj.update!(google_two_factor_code: google_secret)

      #   # TODO: TESTING KARENA PEMANGGILAN DISINI SEPERTINYA SALAH
      #   ccurrency_withdraw(session_orang_id, simbol, amount, withdraw_to)
      # else
      #   { 
      #     success: false,
      #     message: 'Wrong 2FA Token, please try again' 
      #   }
      # end
    else
      { 
        success: false,
        message: '2FA token or OTP is required' 
      }
    end
  
  end

  private 

  def ccurrency_withdraw
    @balance_obj = Balance.where(user_id: @session_orang_id, currency: @simbol).first

    # cari currency, cari fee dan catatkan jumlah setelah fee dikeluarkan
    @amount_after_fee = @amount - @wd_fee

    if @amount > 0 && @amount <= @balance_obj.balance_value

      if @amount_after_fee > 0

        # kurangi saldo user yang ada di database
        @balance_obj.balance_value = @balance_obj.balance_value - @amount
        @balance_obj.save

        puts "------ balace obj"
        puts @balance_obj.to_json
        puts "------ balace obj"

        # Catat di table withdraw
        wd_obj = WithdrawCrypto.new 
        wd_obj.user_id          = @session_orang_id
        wd_obj.amount           = @amount 
        wd_obj.fee              = @wd_fee 
        wd_obj.amount_after_fee = @amount_after_fee 
        wd_obj.status           = 'open'
        wd_obj.to_address       = withdraw_to
        wd_obj.currency         = 'XAU'
        wd_obj.chain_id         = @chain_id
        wd_obj.contract_address = @contract_address
        wd_obj.save 

        {
          success: true,
          withdraw: wd_obj
        }
      else
        {
          success: false,
          message: 'Gagal.<br>Jumlah withdraw setelah dikurangi fee tidak boleh dibawah nol'
        }
      end

    elsif @amount == 0
      {
        success: false,
        message: 'Fail. Zero not allowed'
      }
    else 
      {
        success: false,
        message: 'Fail. Insufficient balance'
      }
    end
  end
end