class RemoveColumnWithdrawCrypto < ActiveRecord::Migration[7.0]
  def change
    remove_column :withdraw_cryptos, :name_bank
    remove_column :withdraw_cryptos, :account_number
  end
end
