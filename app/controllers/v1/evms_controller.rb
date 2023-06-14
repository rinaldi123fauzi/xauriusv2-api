class V1::EvmsController < ApplicationController

  # TODO: Testing!!! karena ini belum di testing
  #
  # Digunakan untuk menyimpan data yang didapat dari aplikasi eth-node
  def erc20_deposit
    # Data yang didapat adalah seperti berikut 
    # {
    #   name: 'Transfer',
    #   contract: 'TokenA',
    #   timestamp: 1676983512,
    #   blockHash: '0x5dd63b02d5969211b213001768c8292dfea6876709977578437e3729d9217991',
    #   blockNumber: 8530671,
    #   transactionHash: '0xc58f0e5ff54b30071d4e4d6f042f5df9ab16b822d91f186dd0a003d14625d276',
    #   transactionIndex: 78,
    #   from: '0x4ff7D7a153876E43FEAdbE8120f78CFd395B6278',
    #   to: '0xAaCa2DA0026C41fD49Bd0636fbD67cf704e34b1D',
    #   logIndex: 106,
    #   values: {
    #     from: '0x4ff7D7a153876E43FEAdbE8120f78CFd395B6278',
    #     to: '0xfcCCfcACD8565D5f7ab31c85997331F6aADA738c',
    #     value: '1000000000000000000'
    #   }
    # }
    data     = params[:data]
    txhash   = params[:txhash].downcase
    to       = params[:to].downcase
    amount   = params[:amount].to_f
    currency = params[:currency]
    evm_chain_id = params[:evm_chain_id]

    if params[:password] == ENV['INTERNAL_PASSWORD']

      # cari apakah address ada?
      wallets = BlockEthAddr.where(address: to.downcase) 

      if wallets.count > 0
        wallet = wallets.first 

        if wallet.user_id != 0

          # dari wallet, ketahuan siapa yang punya address 
          user_id = wallet.user_id

          # jika transaksi ini memang untuk dia, maka recordkan 
          balikan = CcdepositSaveService.call(user_id, txhash, data, currency, amount, evm_chain_id)

          if balikan[:success] == true 
            render json: {
              success: true
            }
          else  
            app_fail_render(balikan[:msg])
          end
        else   
          app_fail_render('Fail. No user')
        end
      else  
        app_fail_render('Fail. No address found')
      end
    else  
      app_fail_render('Fail. Wrong internal password')
    end
  end

  # Digunakan oleh user untuk melakukan request withdraw
  # == Keterangan
  # Untuk semua withdraw, pertama kali yang dilakukan adalah mengurangi saldo dari servis yang dibuat
  # Setelah itu baru withdraw melalui blockchainnya
  # == Params
  # currency, amount, withdraw_to, otp atau google_secret
  # TODO
  # Proses OTP atau google secret
  # Cek apakah memang token ERC20
  def erc20_withdraw 
    balikan = GetUserFromJwtTokenService.call(request.headers["JWT"])
    if balikan[:success] == true 
      orang = balikan[:orang]

      # proses parameter 
      otp              = params[:otp]
      currency         = params[:currency]
      amount           = params[:amount]
      withdraw_to      = params[:withdraw_to]
      chain_id         = params[:chain_id]
      contract_address = params[:contract_address].downcase   # INI NANTI DAPATKAN DARI CONFIG
      
      # karena wd fee pada evm tergantung dari chain yang dipilih, kita harus mencari fee terlebih dahulu 
      block_evm_token_obj = BlockEvmToken.where(chain_id: chain_id, contract_address: contract_address).first 

      if block_evm_token_obj && block_evm_token_obj.wd_fee > 0

        # takut ada hack untuk symbol, maka symbol ini harus langsung dari ccurrency table 
        ccurrency_obj = Ccurrency.where(id: block_evm_token_obj.ccurrency_id).first 
        if ccurrency_obj && currency == ccurrency_obj.ccurrency_symbol

          # sebelum kita lanjut, kita harus check chain_id, apakah ada didalam BlockEvmNetwork 
          block_evm_network_objs = BlockEvmNetwork.where(chain_id: chain_id)

          if block_evm_network_objs.count > 0

            block_evm_network_obj = block_evm_network_objs.first 

            # variable destinationtag gak ada pada ethereum, maka kita kosongkan saja
            destinationtag = '' 

            # TODO: CEK apakah ethreum address valid atau tidak
            if orang[:two_fa_is_active] == true 
              @wd_service_res = WithdrawGeneralService.call(orang[:id], currency, amount, withdraw_to, destinationtag, nil, google_secret, block_evm_token_obj.wd_fee)
            else  
              @wd_service_res = WithdrawGeneralService.call(orang[:id], currency, amount, withdraw_to, destinationtag, otp, nil, block_evm_token_obj.wd_fee)
            end
        
            if @wd_service_res[:success] == true 

              # edit data withdraw ini 
              withdraw_obj = Withdraw.find(@wd_service_res[:withdraw][:id])

              if withdraw_obj 

                # TODO: buat new theread karena ini bisa hold koneksi cukup lama
                # langsung minta transfer erc20
                balikan = EvmTokenTransferService.call(block_evm_token_obj.contract_address, withdraw_to, withdraw_obj.withdraw_amount_after_fee, block_evm_network_obj.rpc_url)

                if balikan['success'] == true 

                  withdraw_obj.withdraw_txhash = balikan['data']['transactionHash']
                  withdraw_obj.withdraw_status = 'close'
                  withdraw_obj.save 

                  render json: {
                    success: true, 
                    msg: 'mantap'
                  }
                else  
                  app_fail_render(balikan[:msg])
                end  
              else  
                app_fail_render("Withdraw not found")  
              end          
            else  
              app_fail_render(@wd_service_res[:message])  
            end
          else  
            app_fail_render('RPC URL not found')  
          end
        else  
          app_fail_render('Currency not supported/fail')  
        end
      else  
        app_fail_render('EVM Token not found')  
      end
    else  
      app_fail_render("Data not found")
    end
  end

  
end
  