module V1
  class WithdrawCryptoController < ApplicationController
    include ActionController::Cookies
    before_action :authenticate_request
    before_action :check_status_kyc

    def index
      withdraws = WithdrawCrypto.where(user_id: decoded_auth_token[:user_id]).order(:id => :desc)
      render json: {
        success: true,
        msg: "Data berhasil diambil.",
        data: withdraws
      }
    end

    def show
      withdraws = WithdrawCrypto.where(id: params[:id], user_id: decoded_auth_token[:user_id]).order(:id => :desc)
      render json: {
        success: true,
        msg: "Data detail berhasil diambil.",
        data: withdraws
      }
    end

    def create

      puts params
      
      # orang = balikan[:orang]

      # proses parameter 
      otp              = params[:otp]
      currency         = 'XAU'
      amount           = params[:amount]
      withdraw_to      = params[:withdraw_to]
      chain_id         = params[:chain_id]
      
      # karena wd fee pada evm tergantung dari chain yang dipilih, kita harus mencari fee terlebih dahulu 
      block_evm_token_obj = BlockEvmToken.where(chain_id: chain_id).first 

      contract_address = block_evm_token_obj.contract_address

      puts block_evm_token_obj.to_json

      if block_evm_token_obj && block_evm_token_obj.wd_fee > 0

        # sebelum kita lanjut, kita harus check chain_id, apakah ada didalam EvmNetwork 
        block_evm_network_objs = EvmNetwork.where(chain_id: chain_id)

        puts block_evm_network_objs.to_json

        if block_evm_network_objs.count > 0

          block_evm_network_obj = block_evm_network_objs.first 

          # TODO: CEK apakah ethreum address valid atau tidak
          @wd_service_res = WithdrawGeneralService.call(
            decoded_auth_token[:user_id], 
            currency, 
            amount,
            withdraw_to, 
            otp, 
            nil, 
            block_evm_token_obj.wd_fee,
            chain_id,
            contract_address
          )
      
          if @wd_service_res[:success] == true 

            # edit data withdraw ini 
            withdraw_obj = WithdrawCrypto.find(@wd_service_res[:withdraw][:id])

            if withdraw_obj 


              # TODO: buat new theread karena ini bisa hold koneksi cukup lama
              # langsung minta transfer erc20
              balikan = EvmTokenTransferService.call(contract_address, withdraw_to, withdraw_obj.amount_after_fee, block_evm_network_obj.rpc_url)

              if balikan['success'] == true 

                withdraw_obj.txhash = balikan['data']['transactionHash']
                withdraw_obj.status = 'close'
                withdraw_obj.save 

                render json: {
                  success: true, 
                  msg: 'Wihtdraw Crypto berhasil',
                  data: withdraw_obj
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
        app_fail_render('EVM Token not found')  
      end
    end

    private

    def decoded_auth_token
      if request.headers["JWT"]
        @decoded_auth_token ||= JsonWebToken.decode(request.headers["JWT"])
      else
        @decoded_auth_token ||= JsonWebToken.decode(cookies[:JWT])
      end
    end

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
      }, status: 401 unless @current_user
    end

  end
end
    