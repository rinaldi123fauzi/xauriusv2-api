json.extract! withdraw, :id, :name_bank, :account_number, :cash_balance, :ammount, :created_at, :updated_at
json.url withdraw_url(withdraw, format: :json)
