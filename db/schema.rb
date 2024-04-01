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

ActiveRecord::Schema[7.1].define(version: 2024_04_01_113902) do
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

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deliveries", force: :cascade do |t|
    t.string "client_email"
    t.string "driver_email"
    t.boolean "fulfilled"
    t.integer "total"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "package_received", default: false
    t.integer "driver_id"
    t.integer "client_id"
    t.string "departure_city"
    t.string "arrival_city"
    t.date "departure_date"
    t.date "arrival_date"
    t.index ["client_id"], name: "index_deliveries_on_client_id"
    t.index ["driver_id"], name: "index_deliveries_on_driver_id"
  end

  create_table "delivery_packages", force: :cascade do |t|
    t.integer "package_id", null: false
    t.integer "delivery_id", null: false
    t.string "departureCity"
    t.string "destinationCity"
    t.string "departureDate"
    t.string "arrivalDate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "weight", precision: 10, scale: 2, default: "0.0", null: false
    t.boolean "received"
    t.boolean "delivered"
    t.index ["delivery_id"], name: "index_delivery_packages_on_delivery_id"
    t.index ["package_id"], name: "index_delivery_packages_on_package_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "delivery_id", null: false
    t.integer "sender_id", null: false
    t.integer "receiver_id", null: false
    t.text "content"
    t.boolean "delivered", default: false
    t.boolean "received", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "delivery_package_id"
    t.index ["delivery_id"], name: "index_messages_on_delivery_id"
    t.index ["delivery_package_id"], name: "index_messages_on_delivery_package_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "price"
    t.integer "category_id", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", default: 13, null: false
    t.decimal "weight"
    t.string "dimensions"
    t.index ["category_id"], name: "index_packages_on_category_id"
    t.index ["user_id"], name: "index_packages_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "delivery_id"
    t.integer "delivery_package_id"
    t.integer "package_id"
    t.integer "client_id"
    t.boolean "payment_done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "client_id"
    t.integer "driver_id"
    t.integer "delivery_id"
    t.integer "timeliness"
    t.integer "communication"
    t.integer "handling"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.text "credit_card_info"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "deliveries", "users", column: "client_id"
  add_foreign_key "deliveries", "users", column: "driver_id"
  add_foreign_key "delivery_packages", "deliveries"
  add_foreign_key "delivery_packages", "packages"
  add_foreign_key "messages", "deliveries"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "packages", "categories"
  add_foreign_key "packages", "users"
end
