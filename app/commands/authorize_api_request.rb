# app/commands/authorize_api_request.rb

class AuthorizeApiRequest
    prepend SimpleCommand
  
    def initialize(auth)
      @auth = auth
    end
  
    def call
      user
    end
  
    private
  
    attr_reader :auth
  
    def user
      @user ||= User.find_by_id_and_email_and_session_id(decoded_auth_token[:user_id],decoded_auth_token[:email],decoded_auth_token[:session_id]) if decoded_auth_token
      @user || errors.add(:token, 'Invalid token') && nil
    end
  
    def decoded_auth_token
      @decoded_auth_token ||= JsonWebToken.decode(auth)
    end
  end
  