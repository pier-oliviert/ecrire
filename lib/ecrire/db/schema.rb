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

ActiveRecord::Schema.define(version: 20160501848734) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "abtests", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: :cascade do |t|
    t.string   "url",        limit: 255
    t.string   "key",        limit: 255
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "favorite"
  end

  create_table "partials", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",      limit: 255, null: false
    t.text     "content"
    t.text     "stylesheet"
    t.text     "javascript"
  end

  create_table "posts", force: :cascade do |t|
    t.text     "stylesheet"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "javascript"
    t.hstore   "properties"
    t.text     "compiled_excerpt"
    t.integer  "tags",                                               array: true
    t.hstore   "content",          default: {"raw"=>"", "html"=>""}
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "titles", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "post_id"
  end

  add_index "titles", ["name"], name: "index_titles_on_name", using: :btree
  add_index "titles", ["post_id"], name: "index_titles_on_post_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",              limit: 255, null: false
    t.string   "encrypted_password", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
