require 'awesome_print'
require 'geokit'
require 'rgeo'
include Geokit::Geocoders

# -------------------------------
# Delete all unless in production
# -------------------------------
if Rails.env != "production" && ENV["force"]
  Location.delete_all
  Project.delete_all
  Event.delete_all
  Sector.delete_all
  Partner.delete_all
  User.delete_all
end

# -------------------------------
# Create parent location
# -------------------------------

factory = ::RGeo::Geographic.simple_mercator_factory()
p1 = factory.point(-179, 89)
p2 = factory.point( 179, 89)
p3 = factory.point( 179,-89)
p4 = factory.point(-179,-89)
ring = factory.linear_ring([p1, p2, p3, p4, p1])
world_geom = factory.polygon(ring)

# World admin_level is set to -1 by convention
# National: 0
# Provincial: 1
world = Location.where(:name => 'World', :admin_level => -1).first_or_create(:geom => world_geom)

# -------------------------------
# Create users
# -------------------------------
gernot  = User.where(:email => 'gernot.ritthaler@caritas.de').first_or_create(
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'admin'
)
Settings.where(user_id: gernot.id).first_or_create!(:location => world)

silvius = User.create(
  :email                 => 'prakkako@caritas.de',
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'admin'
)
#silvius.settings = Settings.create!(:location => world)
Settings.where(user_id: silvius.id).first_or_create!(:location => world)

publisher = User.create(
  :email                 => 'publisher@caritas.de',
  :password              => "caritas123",
  :password_confirmation => "caritas123",
  :role                  => 'publisher'
)
#publisher.settings = Settings.create!(:location => world)
Settings.where(user_id: publisher.id).first_or_create!(:location => world)

shoaib = User.create(
  :email                 => 'shoaib@nomad-labs.com',
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'admin'
)
#shoaib.settings = Settings.create!(:location => world)
Settings.where(user_id: shoaib.id).first_or_create!(:location => world)

public_relations = User.create(
  :email                 => 'public_relations@caritas.de',
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'public_relations'
)
#public_relations.settings = Settings.create!(:location => world)
Settings.where(user_id: public_relations.id).first_or_create!(:location => world)

oea = User.create(
  :email                 => 'oea@caritas.de',
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'public_relations'
)
#oea.settings = Settings.create!(:location => world)
Settings.where(user_id: oea.id).first_or_create!(:location => world)

monika = User.create(
  :email                 => 'monika.hoffmann@caritas.de',
  :password              => "caritas321",
  :password_confirmation => "caritas321",
  :role                  => 'public_relations'
)
#monika.settings = Settings.create!(:location => world)
Settings.where(user_id: monika.id).first_or_create!(:location => world)

# -----------------------------------
# Load Locations data from shapefiles
# -----------------------------------

# load pakistan data
if pakistan = Location.where(:name => "Pakistan").first
  ap "Found Pakistan id: #{pakistan.id}"
else
  ap %x[rake db:load_shapefile \
    shapefile_path="#{Rails.root}/db/raw_data/pakistan/national_boundries_of_pakistan/pakistan_country_bdry.shp" \
    name_field=NAME_1 \
    description_field=descriptio \
    admin_level=0 \
    parent_id=#{world.id} \
    admin_email=#{gernot.email}]
  pakistan = Location.where(:name => "Pakistan").first
  ap "Created Pakistan id: #{pakistan.id}"
end

if names_provinces_of_pakistan = pakistan.children.pluck(:name)
  ap "Found Provinces of Pakistan"
  ap names_provinces_of_pakistan
  provinces_of_pakistan = pakistan.children.all
else
  ap %x[rake db:load_shapefile \
    shapefile_path="#{Rails.root}/db/raw_data/pakistan/provincial_boundaries_of_pakistan/provincial_boundaries_of_pakistan.shp" \
    name_field=NAME_1 \
    description_field=ENGTYPE_1 \
    admin_level=1 \
    parent_id=#{pakistan.id} \
    admin_email=#{gernot.email}]
end

# load Haiti data
if haiti = Location.where(:name => "Republic of Haiti").first
  ap "Found Haiti id: #{haiti.id}"
else
  ap %x[rake db:load_shapefile \
    shapefile_path="#{Rails.root}/db/raw_data/haiti/haiti_national/haiti_national_bdry.shp" \
    name_field=COUNTRY \
    description_field=COMMENT \
    admin_level=0 \
    parent_id=#{world.id} \
    admin_email=#{gernot.email}]
  haiti = Location.where(:name => "Republic of Haiti").first
  ap "Created Haiti id: #{haiti.id}"
end

if names_provinces_of_haiti = haiti.children.pluck(:name)
  ap "Found Provinces of Haiti"
  ap names_provinces_of_haiti
  provinces_of_haiti = haiti.children.all
else
  ap %x[rake db:load_shapefile \
    shapefile_path="#{Rails.root}/db/raw_data/haiti/Haiti_adm1_2000-2010.shp" \
    name_field=ADM1_NAME \
    description_field=COMMENT \
    admin_level=1 \
    parent_id=#{haiti.id} \
    admin_email=#{gernot.email}]
end

# -------------------------------
# Create partners
# -------------------------------
partners = ['UNHCR', 'UNODC', 'ION', 'ILO', 'ICMC', 'JRS', 'COATNET', 'USG'].collect do |name|
  p = Partner.where(:name => name).first_or_create!
  p.user = gernot
  p.save!
  ap p.name
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
  s = Sector.where(:name => name).first_or_create!
  s.user = gernot
  s.save!
  ap s.name
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
      point = location.geom.envelope.centroid

      width  = (country.bbox_projected.max_point.x - country.bbox_projected.min_point.x).abs/2
      height = (country.bbox_projected.max_point.y - country.bbox_projected.min_point.y).abs/2

      x = point.x + width  * rand * 0.1 * [1,-1][rand(2)]
      y = point.y + height * rand * 0.1 * [1,-1][rand(2)]
      z = point.z || 0
      res=GoogleGeocoder.reverse_geocode([y,x])
      e.address = res.full_address
      event_location = Event::GEOM_FACTORY.point(x,y,z)
      e.geom = event_location
      e.user = silvius
      e.save!
    end
  end
end
