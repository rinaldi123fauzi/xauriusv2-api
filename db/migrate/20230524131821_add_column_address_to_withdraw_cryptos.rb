class AddColumnAddressToWithdrawCryptos < ActiveRecord::Migration[7.0]
  def change
    add_column :withdraw_cryptos, :address, :string
  end
end
