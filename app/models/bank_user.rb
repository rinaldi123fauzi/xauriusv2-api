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
class BankUser < ApplicationRecord
  belongs_to :user

  validates :nama_akun, presence: true
  validates :nama_bank, presence: true
  validates :nomor_rekening, presence: true
  validates :status, inclusion: { in: %w(unlock lock), message: "%{value} bukan status yang benar" }
end
