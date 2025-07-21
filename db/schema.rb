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

ActiveRecord::Schema[7.1].define(version: 2025_07_21_103918) do
  create_table "emotion_log_entries", force: :cascade do |t|
    t.integer "emotion_log_id", null: false
    t.integer "emotion_id", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emotion_id"], name: "index_emotion_log_entries_on_emotion_id"
    t.index ["emotion_log_id"], name: "index_emotion_log_entries_on_emotion_log_id"
  end

  create_table "emotion_logs", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_emotion_logs_on_user_id"
  end

  create_table "emotions", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
  end

  create_table "freetext_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "content"
    t.date "date"
    t.boolean "done_offline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_freetext_entries_on_user_id"
  end

  create_table "gratitude_entries", force: :cascade do |t|
    t.text "content"
    t.date "entry_date"
    t.integer "user_id", null: false
    t.integer "gratitude_prompt_id"
    t.string "prompt_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gratitude_prompt_id"], name: "index_gratitude_entries_on_gratitude_prompt_id"
    t.index ["user_id"], name: "index_gratitude_entries_on_user_id"
  end

  create_table "gratitude_entry_tags", force: :cascade do |t|
    t.integer "gratitude_entry_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gratitude_entry_id"], name: "index_gratitude_entry_tags_on_gratitude_entry_id"
    t.index ["tag_id"], name: "index_gratitude_entry_tags_on_tag_id"
  end

  create_table "gratitude_prompts", force: :cascade do |t|
    t.string "title"
    t.boolean "predefined"
    t.boolean "weekly"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_gratitude_prompts_on_user_id"
  end

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
    t.string "description"
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

  create_table "journal_entry_tags", force: :cascade do |t|
    t.integer "journal_entry_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["journal_entry_id"], name: "index_journal_entry_tags_on_journal_entry_id"
    t.index ["tag_id"], name: "index_journal_entry_tags_on_tag_id"
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

  create_table "recharge_exercises", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recharge_logs", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "date"
    t.string "exercise"
    t.boolean "completed"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_recharge_logs_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "emotion_log_entries", "emotion_logs"
  add_foreign_key "emotion_log_entries", "emotions"
  add_foreign_key "emotion_logs", "users"
  add_foreign_key "freetext_entries", "users"
  add_foreign_key "gratitude_entries", "gratitude_prompts"
  add_foreign_key "gratitude_entries", "users"
  add_foreign_key "gratitude_entry_tags", "gratitude_entries"
  add_foreign_key "gratitude_entry_tags", "tags"
  add_foreign_key "gratitude_prompts", "users"
  add_foreign_key "journal_entries", "prompts"
  add_foreign_key "journal_entries", "users"
  add_foreign_key "journal_entry_tags", "journal_entries"
  add_foreign_key "journal_entry_tags", "tags"
  add_foreign_key "prompts", "users"
  add_foreign_key "recharge_logs", "users"
end
