require 'machinist/active_record'

Project.blueprint do
  # Attributes here
end

Location.blueprint do
  # Attributes here
end

Event.blueprint do
  # Attributes here
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
