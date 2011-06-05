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

ActiveRecord::Schema.define(:version => 20110604185344) do

  create_table "articles", :force => true do |t|
    t.column "content", :text
    t.column "published_at", :datetime
    t.column "author_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "articles", ["author_id"], :name => "index_articles_on_author_id"
  add_index "articles", ["published_at"], :name => "index_articles_on_published_at"

  create_table "events", :force => true do |t|
    t.column "title", :string
    t.column "description", :text
    t.column "address", :string
    t.column "project_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "geom", :point, :srid => 4326, :with_z => true
    t.column "user_id", :integer
  end

  add_index "events", ["geom"], :name => "index_events_on_geom", :spatial=> true 
  add_index "events", ["title"], :name => "index_events_on_title"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "images", :force => true do |t|
    t.column "asset", :string
    t.column "title", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "images", ["asset"], :name => "index_images_on_asset"
  add_index "images", ["title"], :name => "index_images_on_title"

  create_table "locations", :force => true do |t|
    t.column "name", :string
    t.column "description", :text
    t.column "admin_level", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "geom", :geometry, :srid => 4326, :null => false
    t.column "user_id", :integer
    t.column "parent_id", :integer
    t.column "projects_count", :integer, :default => 0
  end

  add_index "locations", ["geom"], :name => "index_locations_on_geom", :spatial=> true 
  add_index "locations", ["name"], :name => "index_locations_on_name"
  add_index "locations", ["parent_id"], :name => "index_locations_on_parent_id"
  add_index "locations", ["user_id"], :name => "index_locations_on_user_id"

  create_table "partners", :force => true do |t|
    t.column "name", :string
    t.column "description", :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "user_id", :integer
  end

  add_index "partners", ["name"], :name => "index_partners_on_name"
  add_index "partners", ["user_id"], :name => "index_partners_on_user_id"

  create_table "partners_projects", :id => false, :force => true do |t|
    t.column "partner_id", :integer
    t.column "project_id", :integer
  end

  create_table "projects", :force => true do |t|
    t.column "title", :string, :null => false
    t.column "description", :text
    t.column "admin_id", :integer
    t.column "start_date", :date
    t.column "end_date", :date
    t.column "location_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "user_id", :integer
  end

  add_index "projects", ["title"], :name => "index_projects_on_title"
  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "projects_sectors", :id => false, :force => true do |t|
    t.column "project_id", :integer
    t.column "sector_id", :integer
  end

  add_index "projects_sectors", ["project_id"], :name => "index_projects_sectors_on_project_id"
  add_index "projects_sectors", ["sector_id"], :name => "index_projects_sectors_on_sector_id"

  create_table "sectors", :force => true do |t|
    t.column "name", :string
    t.column "description", :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "user_id", :integer
  end

  add_index "sectors", ["name"], :name => "index_sectors_on_name"
  add_index "sectors", ["user_id"], :name => "index_sectors_on_user_id"

  create_table "settings", :force => true do |t|
    t.column "user_id", :integer
    t.column "location_id", :integer
    t.column "language", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "settings", ["language"], :name => "index_settings_on_language"
  add_index "settings", ["location_id"], :name => "index_settings_on_location_id"

  create_table "users", :force => true do |t|
    t.column "email", :string, :default => "", :null => false
    t.column "encrypted_password", :string, :limit => 128, :default => "", :null => false
    t.column "reset_password_token", :string
    t.column "remember_token", :string
    t.column "remember_created_at", :datetime
    t.column "sign_in_count", :integer, :default => 0
    t.column "current_sign_in_at", :datetime
    t.column "last_sign_in_at", :datetime
    t.column "current_sign_in_ip", :string
    t.column "last_sign_in_ip", :string
    t.column "confirmation_token", :string
    t.column "confirmed_at", :datetime
    t.column "confirmation_sent_at", :datetime
    t.column "password_salt", :string
    t.column "role", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
