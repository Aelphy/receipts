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

ActiveRecord::Schema.define(version: 20160221160215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "amount_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "name",          null: false
    t.float    "exchange_rate", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "currency_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "currency_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "reference_id"
    t.string   "type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "item_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.integer  "status",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer  "receipt_id"
    t.string   "name",           null: false
    t.integer  "price",          null: false
    t.integer  "currency_id",    null: false
    t.float    "amount",         null: false
    t.integer  "amount_type_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "message"
    t.integer  "status",       null: false
    t.string   "type"
    t.integer  "reference_id"
    t.integer  "author_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "receipt_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "receipt_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "receipts", force: :cascade do |t|
    t.integer  "creditor_id"
    t.integer  "currency_id"
    t.string   "shop_name"
    t.integer  "status",                    null: false
    t.float    "discount",    default: 0.0, null: false
    t.integer  "total_price"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.date     "date"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token",              null: false
    t.datetime "expired_at",         null: false
    t.json     "data"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "sessions", ["token"], name: "index_sessions_on_token", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "phone",                          null: false
    t.string   "email"
    t.string   "name"
    t.string   "encrypted_password",             null: false
    t.integer  "login_count",        default: 0, null: false
    t.integer  "failed_login_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["phone"], name: "index_users_on_phone", using: :btree

  add_foreign_key "currency_users", "currencies", name: "currency_users_currency_id_fk"
  add_foreign_key "currency_users", "users", name: "currency_users_user_id_fk"
  add_foreign_key "images", "receipts", column: "reference_id", name: "images_reference_id_fk"
  add_foreign_key "item_users", "items", name: "item_users_item_id_fk"
  add_foreign_key "item_users", "users", name: "item_users_user_id_fk"
  add_foreign_key "items", "amount_types", name: "items_amount_type_id_fk"
  add_foreign_key "items", "currencies", name: "items_currency_id_fk"
  add_foreign_key "items", "receipts", name: "items_receipt_id_fk"
  add_foreign_key "notifications", "receipts", column: "reference_id", name: "notifications_reference_id_fk"
  add_foreign_key "notifications", "users", column: "author_id", name: "notifications_author_id_fk"
  add_foreign_key "notifications", "users", name: "notifications_user_id_fk"
  add_foreign_key "receipts", "currencies", name: "receipts_currency_id_fk"
  add_foreign_key "receipts", "users", column: "creditor_id", name: "receipts_creditor_id_fk"
  add_foreign_key "sessions", "users", name: "sessions_user_id_fk"
end
