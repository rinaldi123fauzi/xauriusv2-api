class WithdrawGeneralService < ApplicationService
  attr_accessor :session_orang_id, :simbol, :amount, :withdraw_to, 
    :otp, :google_secret, :wd_fee

  def initialize(session_orang_id, simbol, amount, withdraw_to, 
    otp, google_secret, wd_fee)
    
    @session_orang_id = session_orang_id 
    @simbol = simbol 
    @amount = amount 
    @withdraw_to = withdraw_to 
    @otp = otp 
    @google_secret = google_secret
    @wd_fee = wd_fee

  end

  def call
    @amount = amount.to_f

    orang_obj = User.find(@session_orang_id)

    if !@otp.nil?
      @otp = @otp.to_i
      # 1. Hapus otp yang lama
      @clear_otp = Orang.find(@session_orang_id)

      if @clear_otp.orang_otp == @otp && @otp != 0

        # hapus otp dengan menjadikan OTP 0
        @clear_otp.orang_otp = 0
        @clear_otp.save

        # TODO: TESTING KARENA PEMANGGILAN DISINI SEPERTINYA SALAH
        ccurrency_withdraw(session_orang_id, simbol, amount, withdraw_to)
      else
        {
          success: false,
          message: "Wrong OTP or OTP used. Please request a new OTP if you don't have one."
        }
      end
    elsif !google_secret.nil?
      if orang_obj.google_authentic?(google_secret)

        # TODO: Coba cek ini.... kenapa harus di update google secretnya?????
        # orang_obj.update!(google_two_factor_code: google_secret)

        # TODO: TESTING KARENA PEMANGGILAN DISINI SEPERTINYA SALAH
        ccurrency_withdraw(session_orang_id, simbol, amount, withdraw_to)
      else
        { success: false,
          message: 'Wrong 2FA Token, please try again' }
      end
    else
      { success: false,
        message: '2FA token or OTP is required' }
    end
  
  end

  private 

  def ccurrency_withdraw(session_orang_id, simbol, amount, withdraw_to)
    @saldo = Saldo.where(orang_id: session_orang_id, ccurrency_symbol: simbol).first
    @my_address = @saldo.saldo_address

    # cari currency, cari fee dan catatkan jumlah setelah fee dikeluarkan
    @amount_after_fee = @amount - @wd_fee

    if @amount > 0 && @amount <= @saldo.saldo_value

      if @amount_after_fee > 0

        # catat semua data
        @wdcc = Withdraw.new
        @wdcc.orang_id                  = session_orang_id
        @wdcc.ccurrency_symbol          = simbol
        @wdcc.withdraw_to               = withdraw_to
        @wdcc.withdraw_amount           = @amount
        @wdcc.withdraw_fee              = @wd_fee
        @wdcc.withdraw_amount_after_fee = @amount_after_fee
        @wdcc.withdraw_status           = 'open'
        @wdcc.withdraw_evm_token        = 'yes'
        @wdcc.save

        # catat dalam history (user)
        blh = Blhistory.new
        blh.orang_id         = session_orang_id
        blh.ccurrency_symbol = simbol
        blh.blhistory_note   = '1. Ccurrency witdraw - Berkurang karena mengajukan withdraw'
        blh.blhistory_data   = @wdcc.to_json
        blh.blhistory_before = @saldo.saldo_value
        blh.blhistory_added  = @amount.to_f
        blh.blhistory_after  = (@saldo.saldo_value - @amount.to_f)
        blh.save

        # kurangi saldo user yang ada di database
        @saldo.saldo_value = @saldo.saldo_value - @amount
        @saldo.save

        # ============== bagian history untuk company =============
        saldo_obj_company = Saldo.where(orang_id: ENV['MASTER_ORANG_ID'], ccurrency_symbol: simbol).first
        saldo_obj_company_sebelum = saldo_obj_company.saldo_value 
        saldo_obj_company_sesudah = saldo_obj_company_sebelum.to_f + @wd_fee.to_f

        # catat balance history untuk company 
        bl_company = Blhistory.new
        bl_company.orang_id         = ENV['MASTER_ORANG_ID']
        bl_company.ccurrency_symbol = simbol
        bl_company.blhistory_note   = 'Balance bertambah diambil dari fee withdraw user'
        bl_company.blhistory_data   = @wdcc.to_json
        bl_company.blhistory_before = saldo_obj_company_sebelum
        bl_company.blhistory_added  = @wd_fee
        bl_company.blhistory_after  = saldo_obj_company_sesudah
        bl_company.save

        # catat di table saldo
        saldo_obj_company.saldo_value = saldo_obj_company_sesudah
        saldo_obj_company.save
        # ============== bagian history untuk company =============

        {
          success: true,
          withdraw: @wdcc
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
    elsif @amount > @saldo.saldo_value
      {
        success: false,
        message: 'Fail. Insufficient balance'
      }
    end
  end
end