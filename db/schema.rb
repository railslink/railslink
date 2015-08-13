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

ActiveRecord::Schema.define(version: 20150808121006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "slack_api_responses", force: :cascade do |t|
    t.text     "method_name",              null: false
    t.boolean  "ok",                       null: false
    t.jsonb    "response",    default: {}, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "slack_api_responses", ["created_at"], name: "index_slack_api_responses_on_created_at", using: :btree
  add_index "slack_api_responses", ["updated_at"], name: "index_slack_api_responses_on_updated_at", using: :btree

end
