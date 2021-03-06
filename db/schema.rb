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

ActiveRecord::Schema.define(version: 2019_04_18_183807) do

  create_table "actors", force: :cascade do |t|
    t.integer "api_id"
    t.string "name"
  end

  create_table "cast_members", force: :cascade do |t|
    t.integer "movie_api_id"
    t.integer "actor_api_id"
    t.integer "movie_id"
    t.integer "actor_id"
    t.string "character_name"
  end

  create_table "directors", force: :cascade do |t|
    t.integer "api_id"
    t.string "name"
  end

  create_table "genres", force: :cascade do |t|
    t.integer "api_id"
    t.string "name"
  end

  create_table "movie_directors", force: :cascade do |t|
    t.integer "movie_api_id"
    t.integer "director_api_id"
    t.integer "movie_id"
    t.integer "director_id"
  end

  create_table "movie_genres", force: :cascade do |t|
    t.integer "movie_api_id"
    t.integer "genre_api_id"
    t.integer "movie_id"
    t.integer "genre_id"
  end

  create_table "movies", force: :cascade do |t|
    t.integer "api_id"
    t.string "name"
    t.text "description"
  end

end
