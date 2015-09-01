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

ActiveRecord::Schema.define(version: 20150901193321) do

  create_table "crest_data", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "iconID"
    t.integer  "volume"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "regional_item_price_data", force: :cascade do |t|
    t.integer  "itemID"
    t.integer  "regionID"
    t.integer  "volume"
    t.integer  "avgPrice"
    t.integer  "lowPrice"
    t.integer  "highPrice"
    t.integer  "orderCount"
    t.datetime "marketDate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
