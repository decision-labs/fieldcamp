# Setting up the development environment from scratch

## Create database

Add `postgis` to the default postgresql template or manually add it after
creating the database

    rake db:create

    # add postgis extension as below or add it to your template_database

    # rails dbconsole # Doesn't work see TODO
    psql caritas_development

    caritas_development=# CREATE EXTENSION IF NOT EXISTS postgis;

    psql caritas_test
    caritas_test=# CREATE EXTENSION IF NOT EXISTS postgis;

Make sure the database migrations are up-to-date: `rake db:migrate:status`


## Seeding data

    rake db:seed

## Loading Shapefiles

### Pakistan

**Pakistan Boundary:**

    rake db:load_shapefile \
      shapefile_path=./db/raw_data/national_boundries_of_pakistan/pakistan_country_bdry.shp \
      name_field=NAME_1 \
      description_field=descriptio \
      admin_level=0 \
      admin_email=gernot.ritthaler@caritas.de

**Pakistan admin_level 1:**

    /db/raw_data/provincial_boundaries_of_pakistan/provincial_boundaries_of_pakistan.shp

### Haiti

**Haiti Boundary:**

    rake db:load_shapefile \
      shapefile_path=./db/raw_data/haiti_national/haiti_national_bdry.shp \
      name_field=COUNTRY \
      description_field=COMMENT \
      admin_level=0 \
      admin_email=gernot.ritthaler@caritas.de

    rake db:load_shapefile \
      shapefile_path=./db/raw_data/haiti/Haiti_adm1_2000-2010.shp \
      name_field=ADM1_NAME \
      description_field=COMMENT \
      admin_level=1 \
      admin_email=gernot.ritthaler@caritas.de

**Afghanistan Boundary:**

**Syria Boundary:**

**Turkey Boundary:**

**Jordan Boundary:**

**Iraq Boundary:**

**Japan Boundary:**

# Development:

## Getting started:

### Services:

#### Run manually:

**Redis:**

    redis-server /usr/local/etc/redis.conf

**Websockets:**

    ruby ./script/websocket_server.rb

#### Run via foreman:

    foreman start

# Testing:

## Automated:

We use guard, just run: `guard start`

## Running tests individually:

Models example: `rspec models/project_spec.rb`

Controllers example: `rspec controllers/projects_controller_spec.rb`

# TODO:

## Update to RGeo:

1. Fix `database.yml` to use RGeo with PostGIS 2.0/PostgreSQL 9.1 <-- is this even possible? RGeo example use PostGIS 1.5.x 
1. figure out how to load PostGIS 2.0 as an extension via `database.yml`
   or a rake task
1. Change the `Location` and `Event` models to use RGeo factories
1. Add a rake task to add PostGIS 2.0 extension
1. Add an after create callback to user to create the user's settings
1. fix the problem of not being able to run `rails dbconsole` with
   postgis as the adapter in the `database.yml` the error received is:
   `Unknown command-line client for caritas_development. Submit a Rails patch to add support!`

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

1. Remove config.encryptor from your initializer;
2. Add t.encryptable to your old migrations;
3. [Optional] Remove password_salt in a new recent migration. Bcrypt does not require it anymore.

----

* In index page add some useful summary info e.g location of project, number of events, last updated (how many days ago)

* FIXME: somehow there are multiple jquery-ui in the project!
