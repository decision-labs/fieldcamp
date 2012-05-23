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

ActiveRecord::Schema.define(:version => 20120223134644) do

  create_table "articles", :force => true do |t|
    t.text     "content"
    t.datetime "published_at"
    t.integer  "author_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "published"
    t.string   "title"
    t.integer  "project_id"
  end

  add_index "articles", ["author_id"], :name => "index_articles_on_author_id"
  add_index "articles", ["project_id"], :name => "index_articles_on_project_id"
  add_index "articles", ["published_at"], :name => "index_articles_on_published_at"
  add_index "articles", ["title"], :name => "index_articles_on_title"

  create_table "distributions", :force => true do |t|
    t.string   "item"
    t.integer  "quantity_of_items"
    t.string   "unit"
    t.string   "recipient"
    t.integer  "number_of_recipients"
    t.integer  "event_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "documents", :force => true do |t|
    t.string   "asset"
    t.string   "title"
    t.text     "description"
    t.integer  "event_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "documents", ["asset"], :name => "index_documents_on_asset"
  add_index "documents", ["title"], :name => "index_documents_on_title"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "address"
    t.integer  "project_id"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.spatial  "geom",        :limit => {:srid=>4326, :type=>"point"}
    t.integer  "user_id"
  end

  add_index "events", ["geom"], :name => "index_events_on_geom", :spatial => true
  add_index "events", ["title"], :name => "index_events_on_title"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "events_partners", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "partner_id"
  end

  add_index "events_partners", ["event_id"], :name => "index_events_partners_on_event_id"
  add_index "events_partners", ["partner_id"], :name => "index_events_partners_on_partner_id"

  create_table "events_sectors", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "sector_id"
  end

  add_index "events_sectors", ["event_id"], :name => "index_events_sectors_on_event_id"
  add_index "events_sectors", ["sector_id"], :name => "index_events_sectors_on_sector_id"

  create_table "images", :force => true do |t|
    t.string   "asset"
    t.string   "title"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "images", ["asset"], :name => "index_images_on_asset"
  add_index "images", ["title"], :name => "index_images_on_title"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "admin_level"
    t.datetime "created_at",                                                                    :null => false
    t.datetime "updated_at",                                                                    :null => false
    t.spatial  "geom",               :limit => {:srid=>4326, :type=>"geometry"}
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "projects_count",                                                 :default => 0
    t.string   "iso_3166_2",         :limit => 2
    t.text     "child_location_ids"
  end

  add_index "locations", ["geom"], :name => "index_locations_on_geom", :spatial => true
  add_index "locations", ["iso_3166_2"], :name => "index_locations_on_iso_3166_2"
  add_index "locations", ["name"], :name => "index_locations_on_name"
  add_index "locations", ["parent_id"], :name => "index_locations_on_parent_id"
  add_index "locations", ["user_id"], :name => "index_locations_on_user_id"

  create_table "partners", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  add_index "partners", ["name"], :name => "index_partners_on_name"
  add_index "partners", ["user_id"], :name => "index_partners_on_user_id"

  create_table "partners_projects", :id => false, :force => true do |t|
    t.integer "partner_id"
    t.integer "project_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "title",       :null => false
    t.text     "description"
    t.integer  "admin_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  add_index "projects", ["title"], :name => "index_projects_on_title"
  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "projects_sectors", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "sector_id"
  end

  add_index "projects_sectors", ["project_id"], :name => "index_projects_sectors_on_project_id"
  add_index "projects_sectors", ["sector_id"], :name => "index_projects_sectors_on_sector_id"

  create_table "sectors", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  add_index "sectors", ["name"], :name => "index_sectors_on_name"
  add_index "sectors", ["user_id"], :name => "index_sectors_on_user_id"

  create_table "settings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.string   "language"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "settings", ["language"], :name => "index_settings_on_language"
  add_index "settings", ["location_id"], :name => "index_settings_on_location_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "password_salt"
    t.string   "role"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
