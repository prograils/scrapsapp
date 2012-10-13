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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121013165435) do

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "membership_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "memberships", ["organization_id"], :name => "index_memberships_on_organization_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "observers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.integer  "membership_id"
    t.integer  "observed_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "observers", ["membership_id"], :name => "index_observers_on_membership_id"
  add_index "observers", ["observed_id"], :name => "index_observers_on_observed_id"
  add_index "observers", ["organization_id"], :name => "index_observers_on_organization_id"
  add_index "observers", ["user_id"], :name => "index_observers_on_user_id"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "user_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "memberships_count", :default => 0
  end

  add_index "organizations", ["slug"], :name => "index_organizations_on_slug", :unique => true
  add_index "organizations", ["user_id"], :name => "index_organizations_on_user_id"

  create_table "scraps", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "organization_id"
    t.boolean  "is_public",       :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "scraps", ["organization_id"], :name => "index_scraps_on_organization_id"
  add_index "scraps", ["slug", "organization_id"], :name => "index_scraps_on_slug_and_organization_id", :unique => true
  add_index "scraps", ["user_id"], :name => "index_scraps_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "single_files", :force => true do |t|
    t.string   "name"
    t.string   "file_name"
    t.string   "directory"
    t.text     "content"
    t.string   "lexer"
    t.string   "lexer_type"
    t.integer  "scrap_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "single_files", ["scrap_id"], :name => "index_single_files_on_scrap_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
