require 'pp'
require 'geo_ruby'
require 'geo_ruby/shp'
include GeoRuby::Shp4r

namespace :db do
  desc "load a shapefile into the locations table."
  task :load_shapefile, [
    :shapefile_path,
    :name_field,
    :description_field,
    :admin_level,
    :admin_email,
    :parent_id,
    :parent_name_field ] => :environment do |t, args|

    example = "\nrake db:load_shapefile shapefile_path=./db/raw_data/haiti/Haiti_adm1_2000-2010.shp name_field=ADM1_NAME description_field=COMMENT admin_level=1 admin_email=gernot.ritthaler@caritas.de [parent_id=23]\n"

    if args[:shapefile_path].nil?
      print "Please provide a path to the .shp file\n"
      print "The path may be relative to the current directory.\n"
      print "EXAMPLE: #{example}\n"
      exit 0
    end
    if args[:name_field].nil?
      print "Please provide a field that maps to name\n"
      print "Example: #{example}\n"
      exit 0
    end
    if args[:description_field].nil?
      print "Please provide a field that maps to description\n"
      print "Example: #{example}\n"
      exit 0
    end
    if args[:admin_level].nil?
      print "Please provide an admin_level for this data\n"
      print "Example: #{example}\n"
      exit 0
    end
    if args[:admin_email].nil?
      print "Please provide an admin user email who will be responsible for this data\n"
      print "Example: #{example}\n"
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

    if !args[:parent_id].nil? && !Location.exists?(args[:parent_id])
      print "Couldn't find any parent location record with an id of #{args[:parent_id]}\n"
      exit 0
    end

    shapefile_path      = args[:shapefile_path]
    name_field          = args[:name_field]
    description_field   = args[:description_field]
    admin_level         = args[:admin_level]
    admin_email         = args[:admin_email]
    parent_id           = args[:parent_id]
    parent_name_field   = args[:parent_name_field]

    shpfile    =  ShpFile.open(shapefile_path)
    admin_user =  User.where(:email => admin_email, :role => "admin").first

    shpfile.each_with_index do |rec,i|
      if parent_name_field
        parent =  Location.find_by_name(rec.data[parent_name_field]) rescue nil
        puts "[shape.rake] Couldn't find a parent with name #{rec.data[parent_name_field]} for #{rec.data[name_field]}" if parent.nil?
      else
        parent =  Location.find(parent_id) rescue nil
      end
      geom = rec.geometry
      name = rec.data[name_field]
      description = rec.data[description_field]
      location = Location.new(:name => name, :admin_level => admin_level)
      location.geom = geom
      location.user = admin_user
      location.parent = parent unless parent.nil?
      location.save!
      puts "#{location.id}"
    end
  end
end
