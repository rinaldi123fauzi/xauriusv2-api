# == Schema Information
#
# Table name: bank_users
#
#  id             :bigint           not null, primary key
#  user_id        :bigint           not null
#  nama_akun      :string
#  nama_bank      :string
#  nomor_rekening :string
#  status         :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class BankUserSerializer < ActiveModel::Serializer
  attributes :id, :nama_akun, :nama_bank, :nomor_rekening, :status
  has_one :user
end
