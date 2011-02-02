require 'pp'
require 'geo_ruby'
require 'geo_ruby/shp'
include GeoRuby::Shp4r

shpfile = ShpFile.open("#{Rails.root}/db/raw_data/provincial_boundaries_of_pakistan/provincial_boundaries_of_pakistan.shp")

if Rails.env != "production"
  Location.delete_all
  Project.delete_all
  Event.delete_all
end

project_titles = ["Education", "Agriculture", "Health", "Flood Relief",
                  "Earthquake Relief", "Reconstruction", "Drought Relief", "Maternal Health"]

events_attributes = [
  {
    :title => "Water Delivery",
    :description => "200 Galons of drinkable water delivered to the village"
  },
  {
    :title => "Grain Delivery",
    :description => "200 tonnes of grain delivered to the village"
  },
  {
    :title => "School Books Delivery",
    :description => "Books delivered to 10 schools in the district"
  }
]

shpfile.each_with_index do |rec, i|
  geom = rec.geometry
  name = rec.data["NAME_1"]
  location = Location.new(:name => name, :admin_level_id => 1)
  location.geom = geom
  location.save!

  project = Project.new( :title => project_titles[i],
                         :description => "With help from partner agencies, Caritas Pakistan has since focused on helping communities with rehabilitation and reconstruction, including road building, small-scale business initiatives and education in disaster preparedness.",
                         :start_date  => 1.year.ago,
                         :end_date    => Date.today + 1.year,
                         :location_id => location.id
  )

  project.save!

  3.times do |i|
    puts "\nbuilding event...\n"
    e = project.events.build(events_attributes[i])
    point = location.geom.envelope.center
    point.with_z = true
    point.x += rand * 0.5 * [1,-1][rand(2)]
    point.y += rand * 0.5 * [1,-1][rand(2)]
    point.z = 0
    e.geom = point
    e.save!
  end

end
