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

ActiveRecord::Schema[7.1].define(version: 2024_12_26_211109) do
  create_table "habit_histories", force: :cascade do |t|
    t.integer "habit_id"
    t.integer "user_id"
    t.date "date"
    t.boolean "completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "habits", force: :cascade do |t|
    t.string "name"
    t.integer "frequency"
    t.integer "user_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_timed"
    t.decimal "duration", precision: 5, scale: 2, default: "0.0"
  end

  create_table "journal_entries", force: :cascade do |t|
    t.text "content", null: false
    t.date "entry_date", null: false
    t.integer "user_id", null: false
    t.integer "prompt_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prompt_title"
    t.index ["prompt_id"], name: "index_journal_entries_on_prompt_id"
    t.index ["user_id"], name: "index_journal_entries_on_user_id"
  end

  create_table "prompts", force: :cascade do |t|
    t.string "title", null: false
    t.boolean "weekly", null: false
    t.integer "user_id"
    t.boolean "predefined", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_prompts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "journal_entries", "prompts"
  add_foreign_key "journal_entries", "users"
  add_foreign_key "prompts", "users"
end
