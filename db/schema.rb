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

ActiveRecord::Schema.define(:version => 20110130230751) do

  create_table "locations", :force => true do |t|
    t.column "name", :string
    t.column "description", :text
    t.column "admin_level_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "geom", :geometry, :srid => 4326, :null => false
  end

  add_index "locations", ["geom"], :name => "index_locations_on_geom", :spatial=> true 

  create_table "people", :force => true do |t|
    t.column "first_name", :string, :null => false
    t.column "last_name", :string, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
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
  end

end
