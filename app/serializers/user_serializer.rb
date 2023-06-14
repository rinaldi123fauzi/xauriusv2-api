# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  username         :string
#  password         :string
#  password_digest  :string
#  name             :string
#  email            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  session_id       :integer
#  is_email_verify  :boolean
#  is_active        :boolean
#  is_usaha         :boolean
#  name_nick        :string
#  gender           :string
#  email_vercode    :string
#  jwt_token        :string
#  pass_reset_token :string
#  phone_valid      :boolean
#  user_login_type  :string
#
class UserSerializer < ActiveModel::Serializer
  attributes :id,
    :username,
    :name,
    :email,
    :is_email_verify,
    :is_active,
    :name_nick,
    :file_npwp_url,
    :file_ktp_url,
    :image_url,
    :status_kyc,
    :npwp_number,
    :phone_number,
    :full_name,
    :id_number,
    :country,
    :address

    def file_npwp_url
      file_npwp = Profile.where(user_id: self.object.id).first
      if file_npwp.file_npwp.attached? 
        ENV['DOMAIN_API'] + Rails.application.routes.url_helpers.rails_blob_url(file_npwp.file_npwp, only_path: true) 
      else  
        "#{ENV['DOMAIN_API']}/images/default-npwp.png"
      end
    end
  
    def file_ktp_url
      file_ktp = Profile.where(user_id: self.object.id).first
      if file_ktp.file_ktp.attached? 
        ENV['DOMAIN_API'] + Rails.application.routes.url_helpers.rails_blob_url(file_ktp.file_ktp, only_path: true) 
      else  
        "#{ENV['DOMAIN_API']}/images/default-ktp.png"
      end
    end
  
    def image_url
      file_image = Profile.where(user_id: self.object.id).first
      if file_image.image.attached? 
        ENV['DOMAIN_API'] + Rails.application.routes.url_helpers.rails_blob_url(file_image.image, only_path: true) 
      else  
        "#{ENV['DOMAIN_API']}/images/default-image.png"
      end
    end

    def status_kyc
      data = Profile.find_by_user_id(self.object.id)
      return data.status_kyc
    end

    def npwp_number
      data = Profile.find_by_user_id(self.object.id)
      return data.npwp_number
    end

    def phone_number
      data = Profile.find_by_user_id(self.object.id)
      return data.phone_number
    end

    def full_name
      data = Profile.find_by_user_id(self.object.id)
      return data.full_name
    end

    def id_number
      data = Profile.find_by_user_id(self.object.id)
      return data.id_number
    end

    def country
      data = Profile.find_by_user_id(self.object.id)
      return data.country
    end

    def address
      data = Profile.find_by_user_id(self.object.id)
      return data.address
    end
end
