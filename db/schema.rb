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

ActiveRecord::Schema.define(version: 20140109210144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "comment_body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree

  create_table "folders", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "folders", ["organization_id"], name: "index_folders_on_organization_id", using: :btree
  add_index "folders", ["slug"], name: "index_folders_on_slug", unique: true, using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "membership_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "memberships", ["organization_id"], name: "index_memberships_on_organization_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "oauth_credentials", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.text     "params"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "oauth_credentials", ["user_id"], name: "index_oauth_credentials_on_user_id", using: :btree

  create_table "observers", force: true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.integer  "membership_id"
    t.integer  "observed_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "observers", ["membership_id"], name: "index_observers_on_membership_id", using: :btree
  add_index "observers", ["observed_id"], name: "index_observers_on_observed_id", using: :btree
  add_index "observers", ["organization_id"], name: "index_observers_on_organization_id", using: :btree
  add_index "observers", ["user_id"], name: "index_observers_on_user_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "user_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "memberships_count", default: 0
    t.string   "logo"
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree
  add_index "organizations", ["user_id"], name: "index_organizations_on_user_id", using: :btree

  create_table "scraps", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "organization_id"
    t.boolean  "is_public",       default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "folder_id"
  end

  add_index "scraps", ["folder_id"], name: "index_scraps_on_folder_id", using: :btree
  add_index "scraps", ["organization_id"], name: "index_scraps_on_organization_id", using: :btree
  add_index "scraps", ["slug", "organization_id"], name: "index_scraps_on_slug_and_organization_id", unique: true, using: :btree
  add_index "scraps", ["user_id"], name: "index_scraps_on_user_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "single_files", force: true do |t|
    t.string   "name"
    t.string   "file_name"
    t.string   "directory"
    t.text     "content"
    t.string   "lexer",      default: "plain_text"
    t.string   "lexer_type"
    t.integer  "scrap_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "single_files", ["scrap_id"], name: "index_single_files_on_scrap_id", using: :btree

  create_table "stars", force: true do |t|
    t.integer  "user_id"
    t.integer  "scrap_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "stars", ["scrap_id"], name: "index_stars_on_scrap_id", using: :btree
  add_index "stars", ["user_id"], name: "index_stars_on_user_id", using: :btree

  create_table "timeline_events", force: true do |t|
    t.integer  "account_id"
    t.string   "event_type"
    t.string   "subject_type"
    t.string   "actor_type"
    t.string   "secondary_subject_type"
    t.string   "extra_scope_type"
    t.integer  "subject_id"
    t.integer  "actor_id"
    t.integer  "secondary_subject_id"
    t.integer  "extra_scope_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "timeline_events", ["account_id"], name: "index_timeline_events_on_account_id", using: :btree
  add_index "timeline_events", ["actor_id", "actor_type"], name: "index_timeline_events_on_actor_id_and_actor_type", using: :btree
  add_index "timeline_events", ["extra_scope_id", "extra_scope_type"], name: "scoped_timeline_events", using: :btree
  add_index "timeline_events", ["secondary_subject_id", "secondary_subject_type"], name: "secondary_subject_timeline_events", using: :btree
  add_index "timeline_events", ["subject_id", "subject_type"], name: "index_timeline_events_on_subject_id_and_subject_type", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "github_profile"
    t.string   "facebook_profile"
    t.string   "oauth_one_time_token"
    t.string   "photo"
    t.string   "twitter_profile"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
