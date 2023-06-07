# == Schema Information
#
# Table name: buys
#
#  id         :bigint           not null, primary key
#  amount_xau :decimal(, )
#  price      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#  amount_idr :decimal(, )
#

# TODO: amount_idr, amount_xau
# price => bisa diambil dari harga database charts (kalau gak salah)
# summary => hasil kalkulasi harga dan jumlah_idr_pembelian (diganti jadi amount_xau)
# 
class Buy < ApplicationRecord
    belongs_to :user
end
