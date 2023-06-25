# == Schema Information
#
# Table name: deposits
#
#  id           :bigint           not null, primary key
#  name_bank    :string
#  total        :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :string
#  user_id      :bigint           not null
#  file_deposit :string
#  bank_id      :bigint           not null
#
class DepositSerializer < ActiveModel::Serializer
  attributes :id,
  :name_bank,
  :total,
  :created_at,
  :updated_at,
  :status,
  :user_id,
  :file_deposit_url

  def file_deposit_url
    if self.object.file_deposit.attached? 
      ENV['DOMAIN_API'] + Rails.application.routes.url_helpers.rails_blob_url(self.object.file_deposit, only_path: true) 
    else  
      "#{ENV['DOMAIN_API']}/images/default-deposit.png"
    end
  end
end
