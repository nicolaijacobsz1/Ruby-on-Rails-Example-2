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

ActiveRecord::Schema.define(version: 2020_03_31_060041) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "attachments", force: :cascade do |t|
    t.string "image_id"
    t.string "file_type"
    t.string "attachmentable_type"
    t.bigint "attachmentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachmentable_type", "attachmentable_id"], name: "index_attachments_on_attachmentable_type_and_attachmentable_id"
  end

  create_table "coaches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coaching_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "flag_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "recommended_for"
    t.string "recommended_examples"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.string "attachment"
    t.bigint "user_id"
    t.bigint "post_id"
    t.integer "likes", default: 0
    t.boolean "flag_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "communities", force: :cascade do |t|
    t.bigint "creator_id"
    t.integer "member_ids", default: [], array: true
    t.string "name"
    t.boolean "flag_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_communities_on_creator_id"
  end

  create_table "configurations", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "param"
    t.string "type"
    t.string "value"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follower_requests", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "following_id"
    t.string "aasm_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id"], name: "index_follower_requests_on_follower_id"
    t.index ["following_id"], name: "index_follower_requests_on_following_id"
  end

  create_table "industries", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "search_keyword", default: [], array: true
    t.boolean "flag_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.string "title"
    t.string "body"
    t.boolean "flag_read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.date "date_issued"
    t.boolean "flag_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "flag_none", default: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.string "attachment"
    t.integer "coach_id"
    t.integer "likes", default: 0
    t.boolean "flag_schedule", default: false
    t.boolean "flag_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "flag_draft", default: false
    t.boolean "flag_private", default: false
    t.index ["coach_id"], name: "index_posts_on_coach_id"
  end

  create_table "qualifications", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "organization_id"
    t.string "credential_id"
    t.string "date_issued"
    t.string "certification_awarded"
    t.boolean "flag_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "organization_name"
    t.index ["organization_id"], name: "index_qualifications_on_organization_id"
    t.index ["user_id"], name: "index_qualifications_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.string "attachment"
    t.string "user_id"
    t.integer "coach_id"
    t.boolean "flag_schedule", default: false
    t.boolean "flag_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saved_items", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "post_id"
    t.boolean "flag_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_saved_items_on_post_id"
    t.index ["user_id"], name: "index_saved_items_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.integer "coach_id"
    t.string "title"
    t.string "body"
    t.integer "service_price_cents", default: 0
    t.string "service_price_currency"
    t.string "attachment_id"
    t.string "status", default: "private"
    t.boolean "flag_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "social_profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.string "platform"
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_social_profiles_on_user_id"
  end

  create_table "specializations", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "search_keyword", default: [], array: true
    t.boolean "flag_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscription_plans", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "price_cents"
    t.string "price_currency"
    t.boolean "flag_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "testimonials", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "testimonialable_id"
    t.string "testimonialable_type"
    t.string "title"
    t.string "body"
    t.integer "ratings", default: 0
    t.boolean "flag_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_testimonials_on_user_id"
  end

  create_table "user_devices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "areas_of_interest", default: [], array: true
    t.string "about"
    t.string "industries", default: [], array: true
    t.string "country_of_origin"
    t.string "summary"
    t.string "role", default: "personal"
    t.string "follower_ids", default: [], array: true
    t.string "area_of_interest", default: [], array: true
    t.string "specializations", default: [], array: true
    t.string "topics", default: [], array: true
    t.string "qualification"
    t.string "profile_image_id"
    t.integer "coaching_type_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "title"
    t.string "location"
    t.string "categories", default: [], array: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "communities", "users", column: "creator_id"
end
