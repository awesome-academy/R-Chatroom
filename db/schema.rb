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

ActiveRecord::Schema.define(version: 2019_04_01_064825) do

  create_table "last_reads", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "reader_id"
    t.bigint "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_last_reads_on_message_id"
    t.index ["reader_id", "message_id"], name: "index_last_reads_on_reader_id_and_message_id", unique: true
    t.index ["reader_id"], name: "index_last_reads_on_reader_id"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "room_id"
    t.bigint "receiver_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "message_id"
    t.boolean "read_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_notifications_on_message_id"
  end

  create_table "room_members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "room_id"
    t.bigint "user_id"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id", "user_id"], name: "index_room_members_on_room_id_and_user_id", unique: true
    t.index ["room_id"], name: "index_room_members_on_room_id"
    t.index ["user_id"], name: "index_room_members_on_user_id"
  end

  create_table "rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "room_name"
    t.string "show_name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_name"], name: "index_rooms_on_room_name", unique: true
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "message_id"
    t.bigint "tagged_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_tags_on_message_id"
    t.index ["tagged_id"], name: "index_tags_on_tagged_id"
  end

  create_table "user_relationships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "relating_id"
    t.bigint "related_id"
    t.index ["related_id"], name: "index_user_relationships_on_related_id"
    t.index ["relating_id", "related_id"], name: "index_user_relationships_on_relating_id_and_related_id", unique: true
    t.index ["relating_id"], name: "index_user_relationships_on_relating_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "user_name"
    t.string "show_name"
    t.string "password_digest"
    t.string "token_digest"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token_digest"], name: "index_users_on_token_digest", unique: true
  end

  add_foreign_key "last_reads", "messages"
  add_foreign_key "last_reads", "users", column: "reader_id"
  add_foreign_key "messages", "rooms"
  add_foreign_key "messages", "users"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "notifications", "messages"
  add_foreign_key "room_members", "rooms"
  add_foreign_key "room_members", "users"
  add_foreign_key "tags", "messages"
  add_foreign_key "tags", "users", column: "tagged_id"
  add_foreign_key "user_relationships", "users", column: "related_id"
  add_foreign_key "user_relationships", "users", column: "relating_id"
end
