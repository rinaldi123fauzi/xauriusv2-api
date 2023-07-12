# == Schema Information
#
# Table name: otps
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  otp        :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  expired_at :datetime
#
class Otp < ApplicationRecord
end
