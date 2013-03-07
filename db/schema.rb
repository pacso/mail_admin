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

ActiveRecord::Schema.define(:version => 20130307130543) do

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.boolean  "enabled",    :default => true
    t.boolean  "can_relay",  :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "mailboxes", :force => true do |t|
    t.integer  "domain_id"
    t.string   "local_part"
    t.string   "password_digest"
    t.string   "exim_password_digest"
    t.boolean  "enabled",                   :default => true
    t.string   "forwarding_address"
    t.boolean  "forwarding_enabled",        :default => false
    t.boolean  "delivery_enabled",          :default => true
    t.boolean  "delete_spam_enabled",       :default => true
    t.float    "delete_spam_threshold",     :default => 7.5
    t.integer  "delete_spam_threshold_int", :default => 75
    t.boolean  "move_spam_enabled",         :default => true
    t.float    "move_spam_threshold",       :default => 3.5
    t.integer  "move_spam_threshold_int",   :default => 35
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
