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

ActiveRecord::Schema.define(version: 2021_03_23_080251) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "slack_channels", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.boolean "is_archived"
    t.boolean "is_general", default: false
    t.boolean "is_private"
    t.text "purpose"
    t.integer "members_count", default: 0
    t.json "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_general"], name: "index_slack_channels_on_is_general"
    t.index ["uid"], name: "index_slack_channels_on_uid"
  end

  create_table "slack_membership_submissions", force: :cascade do |t|
    t.bigint "slack_user_id"
    t.integer "status", default: 0
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "location"
    t.text "introduction"
    t.text "how_hear"
    t.string "linkedin_url"
    t.string "github_url"
    t.string "website_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.inet "ip_address"
    t.index ["email"], name: "index_slack_membership_submissions_on_email", unique: true
    t.index ["slack_user_id"], name: "index_slack_membership_submissions_on_slack_user_id"
    t.index ["status"], name: "index_slack_membership_submissions_on_status"
  end

  create_table "slack_users", force: :cascade do |t|
    t.string "uid"
    t.string "email"
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "tz"
    t.integer "tz_offset"
    t.string "locale"
    t.boolean "is_deleted"
    t.boolean "is_admin"
    t.boolean "is_bot"
    t.json "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_message_at"
    t.string "pronouns"
    t.index ["email"], name: "index_slack_users_on_email"
    t.index ["is_admin"], name: "index_slack_users_on_is_admin"
    t.index ["is_deleted"], name: "index_slack_users_on_is_deleted"
    t.index ["uid"], name: "index_slack_users_on_uid"
    t.index ["username"], name: "index_slack_users_on_username"
  end

end
