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

`infinity_test`

`tail -f log/development.log`

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

[DEVISE] From version 1.2, there is no need to set your encryptor to bcrypt since encryptors are only enabled if you include :encryptable in your models. To update your app, please:

1) Remove config.encryptor from your initializer;
2) Add t.encryptable to your old migrations;
3) [Optional] Remove password_salt in a new recent migration. Bcrypt does not require it anymore.

* In index page add some useful summary info e.g location of project, number of events, last updated (how many days ago)

* FIXME: somehow there are multiple jquery-ui in the project!
