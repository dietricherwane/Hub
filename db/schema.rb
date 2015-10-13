# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151013081824) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "available_wallets", force: true do |t|
    t.integer  "ecommerce_id"
    t.integer  "wallet_id"
    t.boolean  "published"
    t.integer  "unpublished_by"
    t.datetime "unpublished_at"
    t.integer  "published_by"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banks", force: true do |t|
    t.string   "name",       limit: 100
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compensation_modes", force: true do |t|
    t.string   "description"
    t.string   "shortcut"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",       limit: 3
    t.string   "name",       limit: 45
  end

  create_table "ecommerces", force: true do |t|
    t.string   "name",                     limit: 100
    t.string   "url",                      limit: 150
    t.text     "description"
    t.integer  "bank_id"
    t.string   "pdt_url",                  limit: 150
    t.string   "order_already_paid_url",   limit: 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "qualified"
    t.integer  "qualified_by"
    t.datetime "qualified_at"
    t.integer  "unqualified_by"
    t.datetime "unqualified_at"
    t.integer  "user_id"
    t.string   "rib",                      limit: 100
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "ipn_url",                  limit: 150
    t.boolean  "qualification_email_sent"
    t.boolean  "created_in_back_office"
    t.string   "operation_token",          limit: 100
    t.string   "service_token",            limit: 100
    t.string   "token",                    limit: 100
    t.datetime "requalified_at"
    t.integer  "requalified_by"
    t.boolean  "published"
    t.string   "company"
    t.integer  "pos_account_type_id"
    t.string   "firstname"
    t.string   "lastname"
  end

  create_table "parameters", force: true do |t|
    t.string   "back_office_url",     limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "paymoney_wallet_url"
    t.string   "paymoney_url"
  end

  create_table "paymoney_wallet_logs", force: true do |t|
    t.string   "transaction_type"
    t.string   "credit_amount"
    t.string   "checkout_amount"
    t.string   "otp"
    t.string   "pin"
    t.boolean  "status"
    t.text     "error_log"
    t.text     "response_log"
    t.string   "account_number"
    t.string   "remote_ip_address"
    t.string   "agent"
    t.string   "sub_agent"
    t.string   "transaction_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "thumb"
    t.float    "fee"
    t.string   "game_account_token"
    t.string   "account_token"
    t.string   "mobile_money_account_number"
    t.string   "a_account_transfer"
    t.string   "b_account_transfer"
  end

  create_table "pos_account_types", force: true do |t|
    t.string   "name"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.string   "name",       limit: 100
    t.string   "shortcut",   limit: 5
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                   default: "", null: false
    t.string   "encrypted_password",                      default: "", null: false
    t.string   "firstname",                   limit: 100
    t.string   "lastname",                    limit: 100
    t.string   "address",                     limit: 200
    t.string   "phone_number",                limit: 16
    t.string   "mobile_number",               limit: 16
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                           default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                         default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
    t.boolean  "published"
    t.integer  "country_id"
    t.integer  "pos_account_type_id"
    t.string   "company"
    t.text     "activities_description"
    t.string   "rib",                         limit: 24
    t.string   "certified_agent_id"
    t.boolean  "created_on_paymoney_wallet"
    t.string   "identification_token"
    t.string   "bank_code"
    t.string   "wicket_code"
    t.string   "account_number"
    t.string   "paymoney_password"
    t.string   "error_code"
    t.text     "error_message"
    t.string   "paymoney_token"
    t.string   "sub_certified_agent_id"
    t.string   "paymoney_account_number"
    t.string   "wari_sub_certified_agent_id"
    t.integer  "compensation_mode_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "wallets", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id"
    t.boolean  "published"
    t.string   "authentication_token"
  end

end
