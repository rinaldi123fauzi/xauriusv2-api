json.extract! profile, :id, :full_name, :phone_number, :address, :id_number, :npwp_number, :deposit, :created_at, :updated_at
json.url profile_url(profile, format: :json)
