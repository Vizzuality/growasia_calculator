# README

## Grow Asia Carbon Emissions Calculator

This tool is built together with [Winrock](https://www.winrock.org/)
for the [Grow Asia](http://growasia.org/) partnership.

It will allow farmers in South East Asia to run an analysis on their farming
practices and practices changes in terms of their carbon emissions.


## Dependencies

* Ruby 2.3.1
* Rails 5.0.0.1
* Postgresql 9.4


## Project setup

* Make sure you have the correct ruby version installed
* Install the project gems: `bundle install`

* Copy the file `config/database_sample.yml` and rename it to only `database.yml`.
Change configuration for your database in that file.

* Create database: `rake db:create`
* Run migrations: `rake db:migrate`
* Import Geo Locations: `rake import:geo_locations`


## Running the project

* Start the rails server `rails server`
* Point your browser to `http://localhost:3000`
