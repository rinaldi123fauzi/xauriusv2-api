# == Schema Information
#
# Table name: charts
#
#  id         :bigint           not null, primary key
#  copen      :decimal(, )
#  clow       :decimal(, )
#  chigh      :decimal(, )
#  cclose     :decimal(, )
#  cdate      :datetime
#  cdatestr   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Chart < ApplicationRecord
end
