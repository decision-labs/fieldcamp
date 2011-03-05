require 'machinist/active_record'

Project.blueprint do
  title { Faker::Lorem.name }
  description { Faker::Lorem.paragraph }
  user
  location
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
