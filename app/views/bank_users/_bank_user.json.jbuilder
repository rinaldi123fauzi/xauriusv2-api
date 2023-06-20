json.extract! bank_user, :id, :user_id, :nama_akun, :nama_bank, :nomor_rekening, :status, :created_at, :updated_at
json.url bank_user_url(bank_user, format: :json)
