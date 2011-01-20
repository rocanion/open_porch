# Open Porch
* * *

This is the home of Open Porch Rails Engine

## Installation

Open Porch uses [Postgres 9.0](http://www.postgresql.org) and [PostGIS](http://postgis.refractions.net) so we'll assume you have these as well as the [pg gem](https://bitbucket.org/ged/ruby-pg/wiki/Home) installed.


### 1. Create a spatially-enabled database from a template

    createdb -T template_postgis open_porch_development

Checkout the [PostGIS documentation](http://postgis.refractions.net/documentation/manual-1.5/ch02.html#id2630392) for more details

### 2. Add gem definition to your Gemfile:
    
    config.gem 'open_porch'
    
### 3. From the Rails project's root run:
    
    bundle install
    rails g open_porch
    rake db:migrate
    
At this point you should have the open_porch database structure created.
