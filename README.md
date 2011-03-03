# Development:

## Getting started:

`redis-server /usr/local/etc/redis.conf`

`bundle exec ruby ./script/websocket_server.rb`

`rails s`

# Testing:

## Models example:

`bundle exec rspec models/project_spec.rb`

## Controllers example:

`bundle exec rspec controllers/projects_controller_spec.rb`

# TODO:

## Add more tests for

* WebSockets

* User login/logout

* Admin User can create, read, update and delete
  - projects
  - events
  - partners
  - sectors

* Publisher User can create, read, update and delete events

* Publisher User can read everything else

* Locales

* GeoJSON creation