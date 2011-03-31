# Seeding data

## Loading Shapefiles

### Pakistan

* Pakistan Boundary:

<pre>
    rake db:load_shapefile \
    shapefile_path=./db/raw_data/national_boundries_of_pakistan/pakistan_country_bdry.shp \
    name_field=NAME_1 \
    description_field=descriptio \
    admin_level=0 \
    admin_email=gernot.ritthaler@caritas.de
</pre>

* Pakistan admin_level 1:
<pre>
/db/raw_data/provincial_boundaries_of_pakistan/provincial_boundaries_of_pakistan.shp
</pre>

### Haiti

* Haiti Boundary:

rake db:load_shapefile shapefile_path=./db/raw_data/haiti_national/haiti_national_bdry.shp name_field=COUNTRY description_field=COMMENT admin_level=0 admin_email=gernot.ritthaler@caritas.de

rake db:load_shapefile shapefile_path=./db/raw_data/haiti/Haiti_adm1_2000-2010.shp name_field=ADM1_NAME description_field=COMMENT admin_level=1 admin_email=gernot.ritthaler@caritas.de

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

* Add Styles for form validations