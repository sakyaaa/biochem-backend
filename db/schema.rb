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

ActiveRecord::Schema[8.0].define(version: 2026_03_15_000010) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", default: "", null: false
    t.integer "status", default: 0, null: false
    t.bigint "author_id", null: false
    t.bigint "section_id"
    t.integer "views_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_articles_on_author_id"
    t.index ["created_at"], name: "index_articles_on_created_at"
    t.index ["section_id"], name: "index_articles_on_section_id"
    t.index ["status"], name: "index_articles_on_status"
    t.index ["views_count"], name: "index_articles_on_views_count"
  end

  create_table "articles_tags", id: false, force: :cascade do |t|
    t.bigint "article_id", null: false
    t.bigint "tag_id", null: false
    t.index ["article_id", "tag_id"], name: "index_articles_tags_on_article_id_and_tag_id", unique: true
    t.index ["article_id"], name: "index_articles_tags_on_article_id"
    t.index ["tag_id"], name: "index_articles_tags_on_tag_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.string "filename", null: false
    t.string "content_type", null: false
    t.bigint "byte_size", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_attachments_on_article_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "article_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_bookmarks_on_article_id"
    t.index ["user_id", "article_id"], name: "index_bookmarks_on_user_id_and_article_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "article_id", null: false
    t.text "body", null: false
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved"], name: "index_comments_on_approved"
    t.index ["article_id"], name: "index_comments_on_article_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "sections", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_sections_on_slug", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role", default: 0, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "jti", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "view_logs", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "article_id", null: false
    t.datetime "created_at", null: false
    t.index ["article_id"], name: "index_view_logs_on_article_id"
    t.index ["created_at"], name: "index_view_logs_on_created_at"
    t.index ["user_id"], name: "index_view_logs_on_user_id"
  end

  add_foreign_key "articles", "sections"
  add_foreign_key "articles", "users", column: "author_id"
  add_foreign_key "articles_tags", "articles"
  add_foreign_key "articles_tags", "tags"
  add_foreign_key "attachments", "articles"
  add_foreign_key "bookmarks", "articles"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "comments", "articles"
  add_foreign_key "comments", "users"
  add_foreign_key "view_logs", "articles"
  add_foreign_key "view_logs", "users"
end
