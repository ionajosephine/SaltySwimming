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

ActiveRecord::Schema[7.0].define(version: 2023_04_02_152335) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "spots", force: :cascade do |t|
    t.string "name"
    t.decimal "latitude"
    t.decimal "longitude"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "station_id"
    t.integer "condition"
    t.string "notes"
    t.index ["station_id"], name: "index_spots_on_station_id"
    t.index ["user_id"], name: "index_spots_on_user_id"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.string "admiralty_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admiralty_id"], name: "index_stations_on_admiralty_id", unique: true
  end

  create_table "swim_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "spot_id"
    t.date "swim_date"
    t.time "swim_time"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_swim_logs_on_spot_id"
    t.index ["user_id"], name: "index_swim_logs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weekly_swims"
    t.integer "monthly_swims"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "spots", "stations"
  add_foreign_key "spots", "users"
  add_foreign_key "swim_logs", "spots"
  add_foreign_key "swim_logs", "users"
end
