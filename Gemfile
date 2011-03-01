source 'http://rubygems.org'

gem 'rails', '3.0.5'
gem 'pg'
gem 'haml'
gem 'nofxx-georuby', :require => 'geo_ruby'
gem 'postgis_adapter', :git => 'git://github.com/nofxx/postgis_adapter.git'
gem 'hoptoad_notifier'
gem 'jquery-rails'
gem 'em-websocket', :git => 'git://github.com/igrigorik/em-websocket'
gem 'redis'
gem 'json'
gem 'devise'

group :test, :development do
  gem 'sqlite3'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'haml-rails'
  gem 'rails3-generators'
  gem 'machinist', '>= 2.0.0.beta1'
  gem 'dbf'
  gem 'faker'
  gem 'silent-postgres'
end

group :development do
  gem "wirble"
  gem "hirb"
  gem "awesome_print"
  gem 'capistrano'
end

platforms :ruby_18 do
  gem 'SystemTimer'
  gem 'ruby-debug'
end

platforms :ruby_19 do
  gem 'ruby-debug19'
end
