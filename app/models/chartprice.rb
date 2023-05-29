# == Schema Information
#
# Table name: chartprices
#
#  id                  :bigint           not null, primary key
#  chartprice_exchange :string
#  chartprice_datetime :string
#  chartprice_buy      :decimal(, )
#  chartprice_sell     :decimal(, )
#  chartprice_price    :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Chartprice < ApplicationRecord
end
