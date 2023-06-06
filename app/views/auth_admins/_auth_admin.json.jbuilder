json.extract! auth_admin, :id, :username, :password, :password_digest, :name, :email, :created_at, :updated_at
json.url auth_admin_url(auth_admin, format: :json)
