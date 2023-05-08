module JsonWebToken
    def self.encode(payload)
      secret_key = Rails.application.secrets.secret_key_base || Rails.application.credentials.secret_key_base
      JWT.encode(payload, secret_key)
    end
  
    def self.decode(token)
      secret_key = Rails.application.secrets.secret_key_base || Rails.application.credentials.secret_key_base
      body = JWT.decode(token, secret_key)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  
    private
  
    def secret_key
      Rails.application.secrets.secret_key_base || Rails.application.credentials.secret_key_base
    end
end
  