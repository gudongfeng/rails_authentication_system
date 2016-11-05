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

ActiveRecord::Schema.define(version: 20161016223937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_authorizations_on_uid", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                    default: ""
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,           null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "nickname"
    t.integer  "sex"
    t.string   "avatar"
    t.string   "phone"
    t.string   "state",                    default: "available"
    t.boolean  "otp_activation_status",    default: false
    t.string   "otp_code"
    t.datetime "otp_code_activation_time"
    t.integer  "otp_attempts_count",       default: 0
    t.string   "country_code"
    t.index ["nickname"], name: "index_users_on_nickname", unique: true, using: :btree
  end

end
