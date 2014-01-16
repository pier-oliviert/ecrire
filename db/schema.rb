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

ActiveRecord::Schema.define(version: 20140115215122) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abtests", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.string   "url"
    t.string   "key"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partials", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",      null: false
    t.text     "content"
    t.text     "stylesheet"
    t.text     "javascript"
  end

  create_table "posts", force: true do |t|
    t.string   "title",        null: false
    t.string   "slug",         null: false
    t.text     "content"
    t.text     "stylesheet"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "excerpt"
    t.text     "javascript"
  end

  add_index "posts", ["title"], name: "index_posts_on_title", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",              null: false
    t.string   "encrypted_password", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
