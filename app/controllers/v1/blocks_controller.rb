class V1::BlocksController < ApplicationController 

  # protect_from_forgery only: []

  def erc20_deposit_manual
    txhash           = params[:txhash].downcase
    currency         = params[:currency]
    contract_address = params[:contract_address].downcase
    evm_chain_id     = params[:evm_chain_id]

    balikan = GetUserFromJwtTokenService.call(request.headers["JWT"])
    if balikan[:success] == true 
      orang = balikan[:orang]

      # apakah chain_id di support?
      block_evm_networks = BlockEvmNetwork.where(chain_id: evm_chain_id)
      if block_evm_networks.count == 1

        block_evm_network = block_evm_networks.first

        # apakah token yang dimaksud ada didalam
        block_evm_tokens = BlockEvmToken.where(chain_id: evm_chain_id, contract_address: contract_address)
        if block_evm_tokens.count == 1

          block_evm_token = block_evm_tokens.first

          # cari currency obj 
          currency_objs = Ccurrency.where(ccurrency_symbol: currency)

          if currency_objs.count == 1
            currency_obj = currency_objs.first

            # cari juga apakah ada di evm tokens 
            bl_evm_obj = BlockEvmToken.where(contract_address: contract_address).first 

            if bl_evm_obj

              # cari apakah address ada?
              wallets = BlockEthAddr.where(orang_id: orang[:id]) 

              if wallets.count > 0
                wallet = wallets.first 

                res = HTTParty.post(
                  "#{ENV.fetch('DOMAIN_BC_EVM')}/v1/erc20/txhash_check", 
                  :headers => {'Content-Type'=>'application/json'}, 
                  :body => {
                    password: ENV.fetch('INTERNAL_PASSWORD'),
                    txhash: txhash,
                    chain_id: evm_chain_id,
                    rpc_url: block_evm_network.rpc_url,
                    contract_address: contract_address

                  }.to_json,
                )

                # {
                #   "success":true,
                #   "data":{
                #     "tx":{
                #       "accessList":[],
                #       "blockHash":"0x7543c199ff0ee58aa2a7d46c6648d85bf6e8d9a26e5fcfdfe9173277667f2a89",
                #       "blockNumber":8816885,
                #       "chainId":"0x5",
                #       "from":"0x4ff7D7a153876E43FEAdbE8120f78CFd395B6278",
                #       "gas":53065,"gasPrice":"305549283124",
                #       "hash":"0xf76052a24bf540a4ec017016a30faec48f3a300eccb1f1ea98a87f66224c66f8",
                #       "input":"0xa9059cbb0000000000000000000000008d1b83eed917e48fab2922b2bdfcdc2aca55b3900000000000000000000000000000000000000000000000000000008bb2c97000",
                #       "maxFeePerGas":"390285419339",
                #       "maxPriorityFeePerGas":"1500000000",
                #       "nonce":48,
                #       "r":"0x30122db83ddf576ef789bf0519626d38e42f77f38f2d269045d12966e4d5b71b",
                #       "s":"0x67ede61f19469d347dfe826541f05693f30806477b901899587c0b4ca23e7d38",
                #       "to":"0xd5c838010582f5567e87830b56F1ea954A821Cd7",
                #       "transactionIndex":31,
                #       "type":2,
                #       "v":"0x1",
                #       "value":"0"
                #     },
                #     "to":"0x8d1b83EEd917e48FAb2922b2BDFCDc2aca55b390",
                #     "value":"600000000000"
                #   }
                # }

                if res['success'] == true 
                  if res['data']['tx']['to'].downcase == contract_address

                    # deteksi apakah tx ini untuk dia 
                    if wallet.address.downcase == res['data']['to'].downcase

                      # disini kita harus kalkulasi amount dari tokennya 
                      amount  = res['data']['value'].to_f / 10**bl_evm_obj.contract_decimals.to_i 

                      # jika transaksi ini memang untuk dia, maka recordkan 
                      balikan = DepositSaveService.call(orang[:id], txhash, res['data'], currency, amount, evm_chain_id)

                      if balikan[:success] == true 
                        render json: {
                          success: true,
                          msg: res
                        }
                      else  
                        app_fail_render(balikan[:msg])
                      end
                    else  
                      app_fail_render('Not your transaction')  
                    end
                  else  
                    app_fail_render('No contract address')  
                  end
                else
                  app_fail_render('Invalid tx hash')
                end
              else  
                app_fail_render('Fail. No address found')  
              end
            else  
              app_fail_render("Currency not found (2)")  
            end
          else  
            app_fail_render("Currency not found")
          end
        else  
          app_fail_render("Chain ID and Contract Address not supported")  
        end
      else  
        app_fail_render("Chain ID not supported")  
      end
    else
      app_fail_render("User not found")
    end
  end

  # TODO, buatkan support coin disini
  def coin_deposit_manual 
    txhash        = params[:txhash].downcase
    currency      = params[:currency]
    evm_chain_id  = params[:evm_chain_id]

    balikan = GetUserFromJwtTokenService.call(request.headers["JWT"])
    if balikan[:success] == true 
      orang = balikan[:orang]

      # apakah chain_id di support?
      block_evm_networks = BlockEvmNetwork.where(chain_id: evm_chain_id)
      if block_evm_networks.count == 1

        block_evm_token = block_evm_tokens.first

        # cek address dari orang ini 
        blc_addr_obj = BlockEthAddr.where(orang_id: orang[:id]).first 

        if blc_addr_obj

          res = HTTParty.post(
            "#{ENV.fetch('DOMAIN_BC_EVM')}/v1/core/txhash_check", 
            :headers => {'Content-Type'=>'application/json'}, 
            :body => {
              password: ENV.fetch('INTERNAL_PASSWORD'),
              txhash: txhash
            }.to_json,
          )
      
          if res['success'] == true 
            # detek apakah dia yang punya address 
            if res['data']['to'].downcase == blc_addr_obj.address 

              # value yang dikirim sengaja dalam bentuk string dan belum dijadikan satuan eth. Sehingga disini harus kita convert
              amount  = res['data']['value'].to_f / 10**18 

              # TODO: BELUM ADA EVM_CHAIN_ID
              # jika transaksi ini memang untuk dia, maka recordkan 
              balikan = DepositSaveService.call(orang[:id], txhash, res['data'], currency, amount)

              if balikan[:success] == true 
                render json: {
                  success: true
                }
              else  
                app_fail_render(balikan[:msg])
              end
            else
              app_fail_render("This transaction is not directed to you")  
            end
          else  
            app_fail_render("Invalid tx hash")
          end
        else  
          app_fail_render("No address found")
        end
      else
        app_fail_render("Chain ID not support")
      end    
    else
      app_fail_render("User not found")
    end
  end

  def used_ethereum_address_count 
    jumlah = Rails.cache.read("address_used")
    render json: {
      count: jumlah
    }
  end

  def all_ethereum_addresses
    datas = BlockEthAddr.where("orang_id <> 0")

    kembalis = []
    datas.each do |f|
      kembalis.push(f.address)
    end

    render json: kembalis
  end

  def load_eth_address
    address = params[:address].downcase
    db_name = params[:db_name]
    tbl_id  = params[:tbl_id]

    if params[:password] == ENV['ADDR_LOAD_PASSWORD']

      # periksa apakah address sudah ada 
      datas = BlockEthAddr.where(address: address)

      if datas.count == 0
        BlockEthAddr.create({
          address: address,
          db_name: db_name,
          tbl_id: tbl_id
        })

        render json: {
          success: true
        }
      else
        app_fail_render("Sudah terdaftar")  
      end
    else 
      app_fail_render("wrong password")  
    end
  end
end
