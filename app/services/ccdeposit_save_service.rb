class CcdepositSaveService < ApplicationService
  attr_accessor :user_id, :txhash, :data, :currency, :amount, :evm_chain_id

  def initialize(user_id, txhash, data, currency, amount, evm_chain_id)
    @user_id = user_id
    @txhash = txhash 
    @data = data 
    @currency = currency
    @amount = amount 
    @evm_chain_id = evm_chain_id
  end

  def call

    # cari apakah deposit sudah pernah direcordkan
    depos = Ccdeposit.where(ccdeposit_txhash: @txhash)
    if depos.count == 0 

      # recordkan dalam table depo
      depo = Ccdeposit.new 
      depo.user_id           = @user_id 
      depo.ccdeposit_amount  = @amount 
      depo.ccdeposit_data    = @data 
      depo.ccdeposit_txhash  = @txhash
      depo.ccurrency_symbol  = @currency
      depo.evm_chain_id      = @evm_chain_id
      depo.save 

      # cari saldo object
      saldo_obj = Balance.where(currency: @currency, user_id: @user_id).first 
      
      # hitung
      saldo_sebelum = saldo_obj.balance_value
      saldo_sesudah = saldo_sebelum + @amount
      
      # simpan saldo terbaru
      saldo_obj.balance_value = saldo_sesudah 
      saldo_obj.save 

      return {success: true}
    else  
      return {success: false, msg: 'Fail. Recorded already'}
    end
  end
end