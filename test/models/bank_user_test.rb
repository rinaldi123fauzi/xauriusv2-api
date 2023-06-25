# == Schema Information
#
# Table name: bank_users
#
#  id             :bigint           not null, primary key
#  user_id        :bigint           not null
#  nama_akun      :string
#  nama_bank      :string
#  nomor_rekening :string
#  status         :string           default("unlock")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "test_helper"

class BankUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
