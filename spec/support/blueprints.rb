require 'machinist/active_record'
require 'sham'
require 'faker'

Project.blueprint do
  title { Faker::Lorem.name }
  description { Faker::Lorem.paragraph }
  user
  location
  start_date { Date.today }
  end_date { Date.yesterday }
end

Location.blueprint do
  name { Faker::Lorem.name }
  description { Faker::Lorem.paragraph }
  admin_level { 1 }
  geom { GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0,0],[4,0],[4,4],[0,4],[0,0]],[[1,1],[3,1],[3,3],[1,3],[1,1]]],4326) }
end

Event.blueprint do
  title { Faker::Lorem.name }
  description { Faker::Lorem.paragraph }
  address { "Multan, Pakistan" }
  project
  geom { Point.from_x_y_z(rand(70), rand(50), rand(10), 4326) }
end

Sector.blueprint do
  # Attributes here
end

Partner.blueprint do
  # Attributes here
end

User.blueprint do
  email                 { Faker::Internet.email }
  password              { 'secret' }
  password_confirmation { 'secret' }
end

Article.blueprint do
  title { Faker::Lorem.sentence }
  author  { User.make(:role => "public_relations") }
  content { File.open(File.join(Rails.root,"spec","fixtures","example_article.markdown")).read }
  project
end

# Location.blueprint(:child) do
#   name
#   description
#   admin_level
#   user
#   parent
#   geom
# end

# Location.blueprint(:country) do
#   # load a location
# end

Distribution.blueprint do
  # item { Faker::Lorem.words.first }
  # quantity_of_items { rand(100) }
  # unit { Faker::Lorem.words.first }
  event
end