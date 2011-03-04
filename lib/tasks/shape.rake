require 'pp'
require 'geo_ruby'
require 'geo_ruby/shp'
include GeoRuby::Shp4r

namespace :db do
  task :load_shapefile, :shapefile_path, :name_field, :description_field, :admin_level, :admin_email, :needs => :environment do |t, args|
    if args[:shapefile_path].nil?
      print "Please provide a path to the .shp file"
      print "The path may be relative to the current directory.\n"
      print "Example: rake db:load_shapefile shapefile_path=./db/raw_data/haiti/Haiti_adm1_2000-2010.shp name_field=ADM1_NAME description_field=COMMENT admin_level=1 admin_email=gernot.ritthaler@caritas.de\n"
      exit 0
    end
    if args[:name_field].nil?
      print "Please provide a field that maps to name\n"
      print "Example: rake db:load_shapefile shapefile_path=./db/raw_data/haiti/Haiti_adm1_2000-2010.shp name_field=ADM1_NAME description_field=COMMENT admin_level=1 admin_email=gernot.ritthaler@caritas.de\n"
      exit 0
    end
    if args[:description_field].nil?
      print "Please provide a field that maps to name\n"
      print "Example: rake db:load_shapefile shapefile_path=./db/raw_data/haiti/Haiti_adm1_2000-2010.shp name_field=ADM1_NAME description_field=COMMENT admin_level=1 admin_email=gernot.ritthaler@caritas.de\n"
      exit 0
    end
    if args[:admin_level].nil?
      print "Please provide an admin_level for this data\n"
      print "Example: rake db:load_shapefile shapefile_path=./db/raw_data/haiti/Haiti_adm1_2000-2010.shp name_field=ADM1_NAME description_field=COMMENT admin_level=1 admin_email=gernot.ritthaler@caritas.de\n"
      exit 0
    end
    if args[:admin_email].nil?
      print "Please provide an admin user email who will be responsible for this data\n"
      print "Example: rake db:load_shapefile shapefile_path=./db/raw_data/haiti/Haiti_adm1_2000-2010.shp name_field=ADM1_NAME description_field=COMMENT admin_level=1 admin_email=gernot.ritthaler@caritas.de\n"
      exit 0
    end

    if not File::exists?(args[:shapefile_path])
      print "Couldn't find the shapefile.\n"
      exit 0
    end

    if not User.exists?(:email => args[:admin_email], :role => "admin")
      print "Couldn't find any admin users with an email: #{args[:admin_email]}.\n"
      exit 0
    end

    shapefile_path      = args[:shapefile_path]
    name_field          = args[:name_field]
    description_field   = args[:description_field]
    admin_level         = args[:admin_level]
    admin_email         = args[:admin_email]

    shpfile    =  ShpFile.open(shapefile_path)
    admin_user =  User.where(:email => admin_email, :role => "admin").first

    shpfile.each_with_index do |rec,i|
      geom = rec.geometry
      name = rec.data[name_field].humanize
      description = rec.data[description_field].humanize
      location = Location.new(:name => name, :admin_level_id => 1)
      location.geom = geom
      location.user = admin_user
      location.save!
      print "loaded #{[name,description,admin_level].inspect}\n"
    end
  end
end
