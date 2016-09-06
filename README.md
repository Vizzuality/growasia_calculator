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

## Step by step data input

This application relies on two different plugins for a step by step data input
workflow. It uses a ruby gem named [wicked](https://github.com/schneems/wicked)
to manage the two main steps, with a conditional for 'rice' crops, and then
a jQuery plugin [jquery.steps](http://jquery-steps.com/) to split the different
sections of each of the main steps into intermediate steps.

The two main steps are:

* Basic information
* Additional information (which can be either for Rice or Other crops), the
conditional is applied by the `analysis_steps_controller`, that lives inside
`app/controllers/analysis_steps_controller.rb`.

The intermediate steps are defined by the set of:

`<h1>title</h1><section>content</section>` and are initialized in the javascript
file: `app/assets/javascripts/analysis.js`. The views for which it is being
applied live inside: `app/views/analysis_steps/`

## Project setup

* Make sure you have the correct ruby version installed
* Install the project gems: `bundle install`

* Copy the file `config/database_sample.yml` and rename it to only `database.yml`. Change there the configuration for your database. 

* Create database: `rake db:create`
* Run migrations: `rake db:migrate`
* Import Geo Locations: `rake import:geo_locations`


## Running the project

* Start the rails server `rails server`
* Point your browser to `http://localhost:3000`
