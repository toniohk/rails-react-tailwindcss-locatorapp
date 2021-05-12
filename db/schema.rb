# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_18_030404) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "links", force: :cascade do |t|
    t.bigint "search_id", null: false
    t.bigint "surgeon_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "link_type"
    t.index ["search_id"], name: "index_links_on_search_id"
    t.index ["surgeon_id"], name: "index_links_on_surgeon_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.string "phone_number"
    t.string "fax_number"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "private"
    t.float "latitude"
    t.float "longitude"
    t.string "website"
    t.index ["latitude", "longitude"], name: "index_locations_on_latitude_and_longitude"
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "search_results", force: :cascade do |t|
    t.bigint "search_id", null: false
    t.bigint "surgeon_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["search_id"], name: "index_search_results_on_search_id"
    t.index ["surgeon_id"], name: "index_search_results_on_surgeon_id"
  end

  create_table "searches", force: :cascade do |t|
    t.integer "search_radius"
    t.string "procedure_types"
    t.string "zip"
    t.string "area_of_discomfort"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "procedure_type", default: [], array: true
    t.float "latitude"
    t.float "longitude"
    t.index ["latitude", "longitude"], name: "index_searches_on_latitude_and_longitude"
  end

  create_table "surgeons", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "url"
    t.string "suffix"
    t.bigint "location_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "private"
    t.string "procedure_types"
    t.string "phone"
    t.string "procedure_types_array", default: [], array: true
    t.index ["location_id"], name: "index_surgeons_on_location_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "full_name"
    t.datetime "deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "links", "searches"
  add_foreign_key "links", "surgeons"
  add_foreign_key "locations", "users"
  add_foreign_key "search_results", "searches"
  add_foreign_key "search_results", "surgeons"
  add_foreign_key "surgeons", "locations"
end
