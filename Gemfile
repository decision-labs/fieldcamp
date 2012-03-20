source 'http://rubygems.org'

gem 'rails', '3.2.2'
gem 'pg'
gem 'haml'
gem 'em-websocket'
gem 'rgeo'
gem 'rgeo-shapefile'
# gem 'postgis_adapter' (moving to rgeo)
# gem 'georuby'         (moving to rgeo)
gem 'activerecord-postgis-adapter'
gem 'airbrake'
gem 'jquery-rails'
gem 'redis'
gem 'SystemTimer', :platforms => ['ruby_18']
gem 'json'
gem 'devise'
gem 'configatron'
gem 'cancan'
gem 'rdiscount'
gem 'will_paginate', '~> 3.0'
gem 'dalli'
gem 'compass', '>= 0.10.6'
gem 'carrierwave'
gem 'rmagick'
gem 'kaminari'
gem 'squeel'
gem 'nested_form'
gem 'crummy', '~> 1.3.6'

group :test, :development do
  gem 'sqlite3'
  gem 'haml-rails'
  gem 'rails3-generators'
  gem 'dbf'
  gem 'fastercsv'

  gem 'silent-postgres'
  gem 'geokit'
  gem 'hpricot'

  gem 'ruby_parser'
  gem 'ruby-debug', :platforms => ['ruby_18']
  gem 'ruby-debug19', :platforms => ['ruby_19']
end

group :development do
  gem 'wirble'
  gem 'hirb'
  gem 'awesome_print'
  gem 'capistrano'
  gem 'bundle_outdated'
end

group :test do
  gem 'shoulda'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'gherkin'
  gem 'cucumber'
  gem 'cucumber-rails'

  # == for generators ==
  gem 'haml-rails'
  gem 'rails3-generators'
  gem 'web-app-theme'
  gem 'rails-erd'
  gem 'erb2haml' # (used when converting devise views to haml)

  gem "wirble"
  gem "hirb"
  gem "awesome_print"
  gem 'capistrano'

  # == rspec ==
  gem 'rspec'
  gem 'rspec-rails'

  # == guard ==
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-spork'
  gem 'growl'

  gem 'annotate'

  gem 'faker'
  # gem 'ffaker'

  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'rb-fsevent', :require => false
  gem 'spork', '~> 0.9.0.rc'
  gem 'capybara'
  gem 'machinist'
end
