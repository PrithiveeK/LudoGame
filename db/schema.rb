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

ActiveRecord::Schema.define(version: 2020_11_02_115408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string "room", null: false
    t.bigint "player1_id", null: false
    t.bigint "player2_id", null: false
    t.bigint "player3_id"
    t.bigint "player4_id"
    t.datetime "scheduled_at"
    t.string "status", default: "ACTIVE"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "join_window"
    t.index ["player1_id"], name: "index_games_on_player1_id"
    t.index ["player2_id"], name: "index_games_on_player2_id"
    t.index ["player3_id"], name: "index_games_on_player3_id"
    t.index ["player4_id"], name: "index_games_on_player4_id"
  end

  create_table "invites", force: :cascade do |t|
    t.string "code", null: false
    t.bigint "game_id", null: false
    t.string "status", default: "ACTIVE"
    t.bigint "created_by_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_invites_on_created_by_id"
    t.index ["game_id"], name: "index_invites_on_game_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.string "status", default: "NOT_PURCHASED"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_orders_on_product_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "price", default: "0"
    t.string "currency", default: "USD"
    t.string "status", default: "ACTIVE"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_records", primary_key: "user_id", force: :cascade do |t|
    t.boolean "is_online", default: false
    t.boolean "in_game", default: false
    t.integer "number_of_games", default: 0
    t.integer "points", default: 0
    t.integer "level", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "avatar"
    t.index ["user_id"], name: "index_user_records_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "games", "users", column: "player1_id"
  add_foreign_key "games", "users", column: "player2_id"
  add_foreign_key "games", "users", column: "player3_id"
  add_foreign_key "games", "users", column: "player4_id"
  add_foreign_key "invites", "games"
  add_foreign_key "invites", "users", column: "created_by_id"
  add_foreign_key "orders", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "user_records", "users"
end
