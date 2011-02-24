# Open Porch
* * *

## Overview

[Open Porch](http://openporch.org) was created by 2010 [Knight News Challenge](http://www.newschallenge.org/) winner [Front Porch Forum](http://frontporchforum.com) thanks to support from the [John S. and James L. Knight Foundation](http://www.knightfoundation.org/).  

The software was built by [The Working Group, Inc.](http://www.theworkinggroup.ca/).  

Open Porch design is based on experienced gained by operating the successful Front Porch Forum pilot project in Burlington, Vermont, USA, 2006-2010.

Front Porch Forum's mission is to help nearby neighbors connect and build community.  It does that by hosting regional networks of small online neighborhood forums.  By early 2011, 24,000 households subscribed to its Vermont pilot, including half of those in Burlington.  People make great use of FPF to find lost cats, report car break-ins, borrow ladders, recommend plumbers, debate school budgets, announce a blood drive, organize a block party and much more.  Since each posting is shared among clearly identified nearby neighbors, people report that over time they feel more connected to neighbors and better informed about what's going on around them. This leads eventually, for many, to get more involved in local issues and fulfills FPF's mission.

Front Porch Forum's new platform is based on Open Porch.  Open Porch is a Ruby on Rails gem released under an MIT open source license.

**The Knight News Challenge:** KNC is a media innovation contest that aims to advance the future of news by funding new ways to digitally inform communities.

**The Working Group, Inc.:** Since 2002, TWG has designed and built web sites, web applications, iPhone apps, and system integrations for entrepreneurs, mature businesses, governments, and non-profit organizations.


* * *
## Functionality

### Overview

* **User registration:** 
  * A user can choose his neighbourhood on a map by entering his address. The system uses geolocation to direct the user to the closest neighbourhood.
  * Once the user is logged in he can edit his account.
  
* **User authentication:** 
  * This includes the basic login, logout, remember me functionality, forgot password and email verification.
  
* **Neighbourhood forums:** 
  * Each user has access to a forum in his neighbourhood.
  * The posts in a Neighborhood Forum are grouped in issues that are emailed periodically to all the members of the neighbourhood.
  * A user can read the current issue on his Neighbourhood Forum or search for older issues.

* **User participation:** 
  * Users are encouraged to contribute to their Neighbourhood Forum by posting new messages via email of via the website.
  
### Administration

* **Users:**
  * As an administrator you can use the admin interface you can create, edit and delete users in the system.
  * Users can be filtered by name, email or role.

* **Areas:** 
  * As an administrator you have access to all the areas (Neighbourhoods) in the system.
  * Each area is represented by a polygon on a map. The points of an area can be manipulated directly by using the map editor tool provided.
  * From the admin interface you can manage the area details, memberships and issues.
  
* **Issues:** 
  * An area can operate in two distinct modes: immediate and batched.
  * In immediate mode each message posted to a furum is immediatelly send to each user of the forum.
  * In batched mode messages are held back for review by the administrator and can be edited and added to an issue individually. Each issue can then be scheduled individually.
  
* **Reports:** 
  * Areas can be searched by name or location using the admin interface.
  * Each area maintains records of it's activity regarding number of new users, quitters, new posts and new issues which can be visualized in a chart and filtered by date.



* * *
## Installation

Open Porch uses [Postgres 9.0](http://www.postgresql.org) and [PostGIS](http://postgis.refractions.net) so we'll assume you have these as well as the [pg gem](https://bitbucket.org/ged/ruby-pg/wiki/Home) installed.


### 1. Add gem definition to your Gemfile:
    
    gem 'open_porch'
    
### 2. Install your gems:
    
    bundle install
    
### 3. Run the generator:
    
    rails g open_porch
    
### 4. Setup your database.yml file using the sample provided database_example_.yml

    development:
      adapter: postgresql
      encoding: utf8
      schema_search_path: public
      template: template_postgis
      database: open_porch_development
      pool: 5
      username: open_porch
      password:
    
The `template` option is particularly important because it is used on the database creation. 

### 5. Create your spacially enabled database

    rake db:create
    
When you instal the [PostGIS](http://postgis.refractions.net) extension you should make sure you also have the `template_postgis` database generated for you. This database contains all the functions needed for spacial calculations.

Once you run `rake db:create`, a copy of `template_postgis` will be used to create your database.

### 6. Run the migrations
    
    rake db:migrate
    
    
  
* * *
## The generator

    rails g open_porch

The generator will give you a list of files you need to get started. You can and should change these files to serve the purpose of your website.

* **Application controller:** You should use the application controller as a starting point. It calls methods related with user login.
* **Static files:** These are all the javascripts, stylesheets and images used in Open Porch.
* **Sample config files:** These are sample config files that will help you setup your own system.
* **Migrations:** All the migrations needed by Open Porch



* * *
## Configuration

Open Porch uses `config/open_porch.yml` aa it's main configuration file.

### Mass mailing with PostageApp

To send out the issues newsletter to all users in a forum, Open Porch makes use of [PostageApp](http://postageapp.com).

To enable this functionality create a PostageApp account and fill in the respective section in `config/open_porch.yml`


### POP3 server

Open Porch can read emails posted to a POP3 server. 
By looking up the FROM field it can find the user who sent the message. By looking up the TO field it can find the destination furum. This mechanism allows users to communicate directly with their neighbourhood forum via email.

To enable this functionality fill in the respective section in `config/open_porch.yml`

### Advertisement with OpenX

Open Porch displays ads on each forum page. 

To enable this functionality create an OpenX account and fill in the respective section in `config/open_porch.yml`




* * *
## Cronjobs

Open Porch uses the `whenever` gem to send issue newsletters and to fetch new messages from the pop3 server.

Install `whenever` and create you `schedule.rb` file 

    set :output, "log/cron.log"
    job_type :exec, "cd :path && RAILS_ENV=:environment :task :output"

    every 5.minutes do
      exec "./bin/pop3.rb"
    end


