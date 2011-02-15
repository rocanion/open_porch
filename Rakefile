# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

OpenPorch::Application.load_tasks

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "open_porch"
  gem.homepage = "http://github.com/FrontPorchForum/open_porch"
  gem.license = "MIT"
  gem.summary = 'Open Porch is Rails Engine'
  gem.description = ''
  gem.email = "jack@theworkinggroup.ca"
  gem.authors = ['The Working Group Inc']
  gem.add_dependency('rails', '3.0.3')
  gem.add_dependency('pg', '0.10.1')
  gem.add_dependency('haml', '3.0.25')
  gem.add_dependency('spatial_adapter', '1.2.0')
  gem.add_dependency('wristband', '1.0.2')
  gem.add_dependency('formatted_form', '1.0.1')
  gem.add_dependency('geokit', '1.5.0')
  gem.add_dependency('active_link_to', '0.0.6')
  gem.add_dependency('meta_where', '1.0.1')
  gem.add_dependency('meta_search', '1.0.1')
  gem.add_dependency('will_paginate', "~> 3.0.pre2")
  
end
Jeweler::RubygemsDotOrgTasks.new
