# app/commands/authenticate_user.rb

class AuthenticateUser
    prepend SimpleCommand
  
    def initialize(username, password)
      @username = username
      @password = password
    end
  
    def call
      @rand = rand(1111..9999)
      user.update(session_id: @rand)
      @payload = {
        "user_id" => user.id,
        "session_id" => @rand
      }
      JsonWebToken::encode(@payload) if user
    end
  
    private
  
    attr_accessor :username, :password
  
    def user
      user = User.find_by_username(username)
      return user if user && user.authenticate(password)
  
      errors.add :user_authentication, 'invalid credentials'
      nil
    end
  end
  