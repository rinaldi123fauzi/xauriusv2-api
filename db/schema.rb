# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_20_132628) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "antamprices", force: :cascade do |t|
    t.text "antamprice_scaptext"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auth_admins", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "password_digest"
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active"
    t.string "gender"
    t.string "phone"
    t.string "email_vercode"
    t.boolean "is_email_verify"
    t.integer "pass_reset_token"
    t.integer "session_id"
    t.string "jwt_token"
  end

  create_table "balances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "balance_value"
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_balances_on_user_id"
  end

  create_table "bank_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "nama_akun"
    t.string "nama_bank"
    t.string "nomor_rekening"
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bank_users_on_user_id"
  end

  create_table "banks", force: :cascade do |t|
    t.string "name_bank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "block_eth_addrs", force: :cascade do |t|
    t.string "address"
    t.bigint "user_id", default: 0
    t.string "db_name"
    t.bigint "tbl_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "block_evm_tokens", force: :cascade do |t|
    t.bigint "chain_id"
    t.string "contract_address"
    t.integer "contract_decimals"
    t.boolean "tracking"
    t.string "token_name"
    t.string "token_symbol"
    t.bigint "currency_id"
    t.decimal "wd_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "businesses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "nama_usaha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_businesses_on_user_id"
  end

  create_table "buys", force: :cascade do |t|
    t.decimal "amount_xau"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.decimal "amount_idr"
    t.index ["user_id"], name: "index_buys_on_user_id"
  end

  create_table "ccdeposits", force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "ccdeposit_amount"
    t.bigint "ccdeposit_confirmation_count"
    t.text "ccdeposit_data"
    t.string "ccdeposit_status"
    t.string "ccdeposit_txhash"
    t.string "ccurrency_symbol"
    t.bigint "evm_chain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chartprices", force: :cascade do |t|
    t.string "chartprice_exchange"
    t.string "chartprice_datetime"
    t.decimal "chartprice_buy"
    t.decimal "chartprice_sell"
    t.decimal "chartprice_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "charts", force: :cascade do |t|
    t.decimal "copen"
    t.decimal "clow"
    t.decimal "chigh"
    t.decimal "cclose"
    t.datetime "cdate"
    t.string "cdatestr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deposits", force: :cascade do |t|
    t.string "name_bank"
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_deposits_on_user_id"
  end

  create_table "evm_networks", force: :cascade do |t|
    t.string "network_name"
    t.string "rpc_url"
    t.integer "chain_id"
    t.string "currency_symbol"
    t.text "explorer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string "full_name"
    t.string "phone_number"
    t.string "address"
    t.string "id_number"
    t.string "npwp_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "status_kyc", default: "false"
    t.string "country"
    t.string "file_npwp"
    t.string "file_ktp"
    t.string "image"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "sells", force: :cascade do |t|
    t.decimal "amount_xau"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.decimal "amount_idr"
    t.index ["user_id"], name: "index_sells_on_user_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.string "network"
    t.string "address_wallet"
    t.datetime "date"
    t.string "tx_hash"
    t.string "address"
    t.decimal "quantity"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_transfers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "password_digest"
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "session_id"
    t.boolean "is_email_verify"
    t.boolean "is_active"
    t.boolean "is_usaha"
    t.string "name_nick"
    t.string "gender"
    t.string "email_vercode"
    t.string "jwt_token"
    t.string "pass_reset_token"
    t.boolean "phone_valid"
    t.string "user_login_type"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "withdraw_cryptos", force: :cascade do |t|
    t.decimal "xau_amount"
    t.string "status"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.bigint "evm_network_id", null: false
    t.index ["evm_network_id"], name: "index_withdraw_cryptos_on_evm_network_id"
    t.index ["user_id"], name: "index_withdraw_cryptos_on_user_id"
  end

  create_table "withdraws", force: :cascade do |t|
    t.string "name_bank"
    t.integer "account_number"
    t.decimal "ammount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.bigint "user_id", null: false
    t.string "name"
    t.bigint "bank_id", null: false
    t.index ["bank_id"], name: "index_withdraws_on_bank_id"
    t.index ["user_id"], name: "index_withdraws_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "balances", "users"
  add_foreign_key "bank_users", "users"
  add_foreign_key "businesses", "users"
  add_foreign_key "buys", "users"
  add_foreign_key "deposits", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "sells", "users"
  add_foreign_key "transfers", "users"
  add_foreign_key "withdraw_cryptos", "evm_networks"
  add_foreign_key "withdraw_cryptos", "users"
  add_foreign_key "withdraws", "banks"
  add_foreign_key "withdraws", "users"
end
