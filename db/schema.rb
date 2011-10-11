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

ActiveRecord::Schema.define(:version => 20111011195412) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["provider"], :name => "index_authentications_on_provider"
  add_index "authentications", ["uid"], :name => "index_authentications_on_uid"
  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "invitations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "room_id"
    t.string   "name"
    t.string   "email"
    t.integer  "status"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["email"], :name => "index_invitations_on_email"
  add_index "invitations", ["room_id"], :name => "index_invitations_on_room_id"
  add_index "invitations", ["token"], :name => "index_invitations_on_token"
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "memberships", :force => true do |t|
    t.integer  "room_id"
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["role"], :name => "index_memberships_on_role"
  add_index "memberships", ["room_id"], :name => "index_memberships_on_room_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "rooms", :force => true do |t|
    t.integer  "owner_id"
    t.string   "name"
    t.string   "topic"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rooms", ["owner_id"], :name => "index_rooms_on_owner_id"
  add_index "rooms", ["token"], :name => "index_rooms_on_token"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "auth_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["auth_token"], :name => "index_users_on_auth_token"
  add_index "users", ["email"], :name => "index_users_on_email"

end
