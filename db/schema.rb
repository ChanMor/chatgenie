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

ActiveRecord::Schema[8.1].define(version: 2025_10_25_092015) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "reservations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "party_size"
    t.datetime "reservation_time"
    t.integer "table_capacity"
    t.bigint "table_id"
    t.bigint "time_slot_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["table_id"], name: "index_reservations_on_table_id"
    t.index ["time_slot_id", "created_at"], name: "index_reservations_on_time_slot_id_and_created_at"
    t.index ["time_slot_id"], name: "index_reservations_on_time_slot_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "tables", force: :cascade do |t|
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "time_slots", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "max_tables", default: 1, null: false
    t.datetime "start_time", null: false
    t.integer "table_capacity", null: false
    t.datetime "updated_at", null: false
    t.index ["start_time"], name: "index_time_slots_on_start_time"
  end

  create_table "users", force: :cascade do |t|
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "password_digest"
    t.integer "role", default: 0
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "reservations", "tables"
  add_foreign_key "reservations", "time_slots"
  add_foreign_key "reservations", "users"
end
