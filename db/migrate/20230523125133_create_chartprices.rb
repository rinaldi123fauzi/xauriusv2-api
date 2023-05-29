class CreateChartprices < ActiveRecord::Migration[7.0]
  def change
    create_table :chartprices do |t|
      t.string :chartprice_exchange
      t.string :chartprice_datetime
      t.decimal :chartprice_buy
      t.decimal :chartprice_sell
      t.decimal :chartprice_price

      t.timestamps
    end
  end
end
