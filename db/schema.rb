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

ActiveRecord::Schema.define(:version => 20120127103220) do

  create_table "edocs", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "source_id"
    t.string   "file_name",          :limit => 64
    t.string   "title",              :limit => 64
    t.text     "description",        :limit => 2048
    t.string   "website",            :limit => 64
    t.string   "language",           :limit => 5
    t.string   "timezone",           :limit => 16
    t.string   "schedule",           :limit => 32
    t.integer  "next_run"
    t.string   "conversion",         :limit => 128
    t.string   "format",             :limit => 4
    t.string   "device",             :limit => 16
    t.string   "recipe_name",        :limit => 64
    t.string   "comment",            :limit => 256
    t.integer  "cost",                               :default => 0
    t.integer  "computime"
    t.boolean  "requires_login"
    t.boolean  "is_mailed"
    t.boolean  "is_approved"
    t.boolean  "has_private_recipe"
    t.boolean  "has_error"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "edocs", ["owner_id"], :name => "index_edocs_on_owner_id"
  add_index "edocs", ["source_id"], :name => "index_edocs_on_source_id"

  create_table "sources", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "website"
    t.string   "language"
    t.string   "timezone"
    t.string   "schedule"
    t.string   "conversion"
    t.string   "recipe_name"
    t.integer  "cost",           :default => 0
    t.boolean  "requires_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sources", ["recipe_name"], :name => "index_sources_on_recipe_name"

  create_table "users", :force => true do |t|
    t.string   "account_email",          :limit => 64,                :null => false
    t.string   "device_email",           :limit => 64
    t.string   "device",                 :limit => 16
    t.string   "format",                 :limit => 4,                 :null => false
    t.string   "timezone",               :limit => 16
    t.string   "username",               :limit => 16
    t.integer  "computime",                            :default => 0
    t.integer  "credit",                               :default => 0
    t.boolean  "is_admin"
    t.string   "encrypted_password",     :limit => 64
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unconfirmed_email"
  end

end
