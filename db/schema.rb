# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_09_045708) do

  create_table "episode_recognition_alternatives", force: :cascade do |t|
    t.integer "episode_recognition_result_id", null: false
    t.float "confidence"
    t.text "transcript"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["episode_recognition_result_id"], name: "index_recognition_alternatives_on_recognition_result_id"
  end

  create_table "episode_recognition_results", force: :cascade do |t|
    t.integer "episode_id", null: false
    t.integer "channel_tag"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["episode_id"], name: "index_episode_recognition_results_on_episode_id"
  end

  create_table "episode_recognition_words", force: :cascade do |t|
    t.integer "episode_recognition_alternative_id", null: false
    t.string "word"
    t.integer "speaker_tag"
    t.integer "end_time", limit: 8
    t.integer "start_time", limit: 8
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["episode_recognition_alternative_id"], name: "index_words_on_alternative_id"
  end

  create_table "episodes", force: :cascade do |t|
    t.string "title"
    t.string "enclosure_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "podcast_id"
    t.string "guid"
    t.index ["guid"], name: "index_episodes_on_guid"
    t.index ["podcast_id"], name: "index_episodes_on_podcast_id"
  end

  create_table "podcasts", force: :cascade do |t|
    t.string "name"
    t.string "rss_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scripts", force: :cascade do |t|
    t.string "audio_url"
    t.string "title"
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "episode_recognition_alternatives", "episode_recognition_results"
  add_foreign_key "episode_recognition_results", "episodes"
  add_foreign_key "episode_recognition_words", "episode_recognition_alternatives"
  add_foreign_key "episodes", "podcasts"
end
