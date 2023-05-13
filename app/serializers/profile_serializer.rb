# == Schema Information
#
# Table name: profiles
#
#  id           :bigint           not null, primary key
#  full_name    :string
#  phone_number :string
#  address      :string
#  id_number    :integer
#  npwp_number  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#  status_kyc   :boolean          default(FALSE)
#  country      :string
#  file_npwp    :string
#  file_ktp     :string
#  image        :string
#
class ProfileSerializer < ActiveModel::Serializer
  attributes :id,
    :full_name,
    :phone_number,
    :address,
    :id_number,
    :npwp_number,
    :user_id,
    :status_kyc,
    :country,

    :file_npwp_url,
    :file_ktp_url,
    :image_url,
    
    :created_at,
    :updated_at   


  def file_npwp_url
    if self.object.file_npwp.attached? 
      ENV['DOMAIN_API'] + Rails.application.routes.url_helpers.rails_blob_url(self.object.file_npwp, only_path: true) 
    else  
      "#{ENV['DOMAIN_API']}/images/default-npwp.png"
    end
  end

  def file_ktp_url
    if self.object.file_ktp.attached? 
      ENV['DOMAIN_API'] + Rails.application.routes.url_helpers.rails_blob_url(self.object.file_ktp, only_path: true) 
    else  
      "#{ENV['DOMAIN_API']}/images/default-ktp.png"
    end
  end

  def image_url
    if self.object.image.attached? 
      ENV['DOMAIN_API'] + Rails.application.routes.url_helpers.rails_blob_url(self.object.image, only_path: true) 
    else  
      "#{ENV['DOMAIN_API']}/images/default-image.png"
    end
  end
    
  
end
