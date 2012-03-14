source 'http://rubygems.org'

gem 'rails', '3.0.9'
# gem 'rake', '0.8.7'
gem 'pg'
gem 'haml'
gem 'georuby',          :git => 'git://github.com/nofxx/georuby.git', :require => 'geo_ruby'
gem 'postgis_adapter',  :git => 'git://github.com/nofxx/postgis_adapter.git'
gem 'em-websocket',     :git => 'git://github.com/igrigorik/em-websocket'
gem 'airbrake'
gem 'jquery-rails'
gem 'redis'
gem 'SystemTimer', :platforms => ['ruby_18']
gem 'json'
gem 'devise'
gem 'configatron'
gem 'cancan'
gem 'rdiscount'
gem 'will_paginate', "~> 3.0.pre2"
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
  gem "gherkin", "~> 2.4.1"
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'pickle'

  gem 'dbf'

  gem 'silent-postgres'
  gem 'geokit'
  gem 'hpricot'

  gem 'ruby_parser'
  gem 'ruby-debug', :platforms => ['ruby_18']
  gem 'ruby-debug19', :platforms => ['ruby_19']
end

group :development do
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
end

group :test do
  gem "shoulda"
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'rb-fsevent', :require => false
  gem 'spork', '~> 0.9.0.rc'
  gem 'capybara'
  gem 'machinist'
end

gem 'faker'
gem 'ffaker'
