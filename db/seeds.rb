require 'geo_ruby'
require 'geo_ruby/shp'
include GeoRuby::Shp4r

shpfile = ShpFile.open("#{Rails.root}/db/raw_data/provincial_boundaries_of_pakistan/provincial_boundaries_of_pakistan.shp")

if Rails.env != "production"
  Location.delete_all
  Project.delete_all
end

project_titles = [
                  "Education", "Agriculture", "Health", "Flood Relief", 
                  "Earthquake Relief", "Reconstruction", "Drought Relief", "Maternal Health"]

shpfile.each_with_index do |rec, i|
  geom = rec.geometry
  name = rec.data["NAME_1"]
  location = Location.new(:name => name, :admin_level_id => 1)
  location.geom = geom
  location.save!

  project = Project.new( :title => project_titles[i],
                         :description => "With help from partner agencies, Caritas Pakistan has since focused on helping communities with rehabilitation and reconstruction, including road building, small-scale business initiatives and education in disaster preparedness",
                         :start_date  => 1.year.ago,
                         :end_date    => Date.today + 1.year,
                         :location_id => location.id
  )

  project.save!
end
