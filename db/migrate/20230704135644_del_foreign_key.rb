class DelForeignKey < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :withdraw_cryptos, :evm_networks
  end
end

