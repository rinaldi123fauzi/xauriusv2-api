# == Schema Information
#
# Table name: antamprices
#
#  id                  :bigint           not null, primary key
#  antamprice_scaptext :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Antamprice < ApplicationRecord
end
