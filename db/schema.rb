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

ActiveRecord::Schema.define(:version => 20101014181922) do

  create_table "authentications", :force => true do |t|
    t.string   "auth_method"
    t.string   "username"
    t.string   "password"
    t.string   "oauth_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "auth_default", :default => false
  end

  create_table "endpoints", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
  end

  create_table "global_parameters", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parameter_sets", :force => true do |t|
    t.string   "name"
    t.integer  "endpoint_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "http_method"
  end

  create_table "parameters", :force => true do |t|
    t.string   "name"
    t.string   "example"
    t.boolean  "required",         :default => false
    t.integer  "parameter_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "p_type"
  end

  create_table "response_members", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "example"
    t.integer  "parameter_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
