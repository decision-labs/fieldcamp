require 'pp'
require 'geo_ruby'
require 'geo_ruby/shp'
include GeoRuby::Shp4r

shpfile = ShpFile.open("#{Rails.root}/db/raw_data/provincial_boundaries_of_pakistan/provincial_boundaries_of_pakistan.shp")

if Rails.env != "production"
  Location.delete_all
  Project.delete_all
  Event.delete_all
  Sector.delete_all
  Partner.delete_all
  User.delete_all
end

gernot  = User.create(
  :email                 => 'gernot.ritthaler@caritas.de',
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'admin'
)
# gernot.confirm!

silvius = User.create(
  :email                 => 'prakkako@caritas.de',
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'admin'
)
# silvius.confirm!

publisher = User.create(
  :email                 => 'publisher@caritas.de',
  :password              => "caritas123",
  :password_confirmation => "caritas123",
  :role                  => 'publisher'
)
# publisher.confirm!


partners = ['UNHCR', 'UNODC', 'ION', 'ILO', 'ICMC', 'JRS', 'COATNET', 'USG'].collect do |name|
  p = Partner.new(:name => name)
  p.user = gernot
  p.save!
  p
end

sectors = [
  # 'Emergency Telecommunications',
  # 'Information Management',
  # 'Gender Based Violence',
  # 'Child Protection',
  # 'Camp Coordination / Management',
  # 'Logistics',
  # 'Mine Action',
  # 'Protection',
  # 'Agriculture'
  # 'Community Restoration / Early Recovery'

  'Food Aid and Nutrition',
  'Non-food items (NFI)',
  'Water, Sanitation and Hygiene (WASH)',
  'Shelter',
  'Health',
  'Education',
  'Livelihoods',
  'Partner Support'
].collect{ |name|
  s = Sector.new(:name => name)
  s.user = gernot
  s.save!
  s
}

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
  location = Location.new(:name => name, :admin_level => 1)
  location.geom = geom
  location.user = gernot
  location.save!

  project = Project.new( :title       => project_titles[i],
                         :description => "With help from partner agencies, Caritas Pakistan has since focused on helping communities with rehabilitation and reconstruction, including road building, small-scale business initiatives and education in disaster preparedness.",
                         :start_date  => 1.year.ago,
                         :end_date    => Date.today + 1.year,
                         :location_id => location.id
  )

  project.sectors  << sectors.shuffle![0..1]
  project.partners << partners.shuffle![0..1]
  project.user = gernot
  project.save!

  3.times do |i|
    # puts "\nbuilding event...\n"
    e = project.events.build(events_attributes[i])
    point = location.geom.envelope.center
    point.with_z = true
    point.x += rand * 0.5 * [1,-1][rand(2)]
    point.y += rand * 0.5 * [1,-1][rand(2)]
    point.z = 0
    e.geom = point
    e.user = silvius
    e.save!
  end

end
