require 'pp'
require 'geokit'
include Geokit::Geocoders

# TODO: set locations for new users by creating a world location by default and set to that
# TODO: create world location first

# -------------------------------
# Delete all unless in production
# -------------------------------
if Rails.env != "production"
  Location.delete_all
  Project.delete_all
  Event.delete_all
  Sector.delete_all
  Partner.delete_all
  User.delete_all
end

# -------------------------------
# Create users
# -------------------------------
gernot  = User.create(
  :email                 => 'gernot.ritthaler@caritas.de',
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'admin'
)
gernot.settings = Settings.create!

silvius = User.create(
  :email                 => 'prakkako@caritas.de',
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'admin'
)
silvius.settings = Settings.create!

publisher = User.create(
  :email                 => 'publisher@caritas.de',
  :password              => "caritas123",
  :password_confirmation => "caritas123",
  :role                  => 'publisher'
)
publisher.settings = Settings.create!

shoaib = User.create(
  :email                 => 'shoaib@nomad-labs.com',
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'admin'
)
shoaib.settings = Settings.create!

public_relations = User.create(
  :email                 => 'public_relations@caritas.de',
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'public_relations'
)
public_relations.settings = Settings.create!

oea = User.create(
  :email                 => 'oea@caritas.de',
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'public_relations'
)
oea.settings = Settings.create!(:location => Location.find_by_name('World'))

monika = User.create(
  :email                 => 'monika.hoffmann@caritas.de',
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'public_relations'
)
monika.settings = Settings.create!(:location => Location.find_by_name('World'))

# -----------------------------------
# Load Locations data from shapefiles
# -----------------------------------

# load pakistan data
puts %x[rake db:load_shapefile \
  shapefile_path="#{Rails.root}/db/raw_data/national_boundries_of_pakistan/pakistan_country_bdry.shp" \
  name_field=NAME_1 \
  description_field=descriptio \
  admin_level=0 \
  admin_email=#{gernot.email}]
pakistan = Location.where(:name => "Pakistan").first
puts "Created Pakistan id: #{pakistan.id}"

puts %x[rake db:load_shapefile \
  shapefile_path="#{Rails.root}/db/raw_data/provincial_boundaries_of_pakistan/provincial_boundaries_of_pakistan.shp" \
  name_field=NAME_1 \
  description_field=ENGTYPE_1 \
  admin_level=1 \
  parent_id=#{pakistan.id} \
  admin_email=#{gernot.email}]

# load Haiti data
puts %x[rake db:load_shapefile \
  shapefile_path="#{Rails.root}/db/raw_data/haiti_national/haiti_national_bdry.shp" \
  name_field=COUNTRY \
  description_field=COMMENT \
  admin_level=0 \
  admin_email=#{gernot.email}]
haiti = Location.where(:name => "Republic of Haiti").first
puts "Created Haiti id: #{haiti.id}"

puts %x[rake db:load_shapefile \
  shapefile_path="#{Rails.root}/db/raw_data/haiti/Haiti_adm1_2000-2010.shp" \
  name_field=ADM1_NAME \
  description_field=COMMENT \
  admin_level=1 \
  parent_id=#{haiti.id} \
  admin_email=#{gernot.email}]

# -------------------------------
# Create partners
# -------------------------------
partners = ['UNHCR', 'UNODC', 'ION', 'ILO', 'ICMC', 'JRS', 'COATNET', 'USG'].collect do |name|
  p = Partner.new(:name => name)
  p.user = gernot
  p.save!
  p
end

# -------------------------------
# Create sectors
# -------------------------------
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

# ------------------------------------------
# Prepare attributes for projects and events
# ------------------------------------------

project_titles = ["Education", "Agriculture", "Health", "Flood Relief", "Sanitation",
                 "Rural Development", "Earthquake Relief", "Reconstruction",
                 "Drought Relief", "Maternal Health", "Emergency Response"]

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

proj_desc = "With help from partner agencies, Caritas Pakistan has since focused on helping communities with rehabilitation and reconstruction, including road building, small-scale business initiatives and education in disaster preparedness."

# ----------------------------------------------
# Load for projects and events for each country
# ----------------------------------------------
[pakistan, haiti].each do |country|

  country.children.each_with_index do |location, i|
    project = Project.new( :title       => project_titles[i],
                           :description => proj_desc,
                           :start_date  => 1.year.ago,
                           :end_date    => Date.today + 1.year)

    project.sectors   << sectors.shuffle![0..1]
    project.partners  << partners.shuffle![0..1]
    project.user      = gernot
    project.location  = location
    project.save!

    3.times do |i|
      e = project.events.build(events_attributes[i])
      point = location.geom.envelope.center

      width  = (country.geom.envelope.upper_corner.x - country.geom.envelope.lower_corner.x).abs/2
      height = (country.geom.envelope.upper_corner.y - country.geom.envelope.lower_corner.y).abs/2

      point.with_z = true
      point.x += width  * rand * 0.1 * [1,-1][rand(2)]
      point.y += height * rand * 0.1 * [1,-1][rand(2)]
      point.z = 0
      res=GoogleGeocoder.reverse_geocode([point.y,point.x])
      e.address = res.full_address
      e.geom = point
      e.user = silvius
      e.save!
    end
  end
end
