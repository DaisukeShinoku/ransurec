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

ActiveRecord::Schema[8.0].define(version: 2025_03_16_093346) do
  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.integer "match_format", default: 1, null: false
    t.integer "number_of_coats", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "match_players", force: :cascade do |t|
    t.integer "match_id", null: false
    t.integer "member_id", null: false
    t.integer "side", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_players_on_match_id"
    t.index ["member_id"], name: "index_match_players_on_member_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "coat_num", default: 1, null: false
    t.integer "sequence_num", default: 1, null: false
    t.integer "match_format", default: 1, null: false
    t.integer "home_score", default: 0, null: false
    t.integer "away_score", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_matches_on_event_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "event_id", null: false
    t.string "display_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_players_on_event_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "match_players", "matches"
  add_foreign_key "match_players", "members"
  add_foreign_key "matches", "events"
  add_foreign_key "players", "events"
end
