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

ActiveRecord::Schema[7.0].define(version: 2023_05_17_134135) do
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

  create_table "balances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "balance_value"
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_balances_on_user_id"
  end

  create_table "businesses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "nama_usaha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_businesses_on_user_id"
  end

  create_table "buys", force: :cascade do |t|
    t.decimal "spend"
    t.decimal "summary"
    t.datetime "date"
    t.decimal "price"
    t.decimal "quantity"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_buys_on_user_id"
  end

  create_table "deposits", force: :cascade do |t|
    t.string "name_bank"
    t.decimal "unit_price"
    t.decimal "quantity"
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date"
    t.string "order"
    t.bigint "user_id", null: false
    t.string "status"
    t.index ["user_id"], name: "index_deposits_on_user_id"
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
    t.boolean "status_kyc", default: false
    t.string "country"
    t.string "file_npwp"
    t.string "file_ktp"
    t.string "image"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "sells", force: :cascade do |t|
    t.decimal "sell"
    t.decimal "summary"
    t.datetime "date"
    t.decimal "quantity"
    t.decimal "price"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
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
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "withdraws", force: :cascade do |t|
    t.string "name_bank"
    t.integer "account_number"
    t.decimal "cash_balance"
    t.decimal "ammount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date"
    t.string "order"
    t.decimal "withdraw"
    t.integer "status"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_withdraws_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "balances", "users"
  add_foreign_key "businesses", "users"
  add_foreign_key "buys", "users"
  add_foreign_key "deposits", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "sells", "users"
  add_foreign_key "transfers", "users"
  add_foreign_key "withdraws", "users"
end
