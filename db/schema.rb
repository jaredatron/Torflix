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

ActiveRecord::Schema.define(version: 20150722163402) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "episodes", force: :cascade do |t|
    t.integer  "show_id",                 null: false
    t.string   "name",                    null: false
    t.string   "normalized_name",         null: false
    t.string   "magnet_link",             null: false
    t.integer  "episode_number"
    t.integer  "season_number"
    t.integer  "seasonal_episode_number"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "episodes", ["show_id", "normalized_name"], name: "index_episodes_on_show_id_and_normalized_name", unique: true, using: :btree

  create_table "shows", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "normalized_name", null: false
    t.integer  "showrss_id"
    t.string   "eztv_id"
    t.string   "artwork_url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "shows", ["eztv_id"], name: "index_shows_on_eztv_id", unique: true, using: :btree
  add_index "shows", ["normalized_name"], name: "index_shows_on_normalized_name", unique: true, using: :btree
  add_index "shows", ["showrss_id"], name: "index_shows_on_showrss_id", unique: true, using: :btree

end
