json.extract! user, :id, :username, :password, :password_digest, :name, :email, :created_at, :updated_at
json.url user_url(user, format: :json)
