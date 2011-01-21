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
  gem.add_dependency('rails', '>=3.0.3')
  gem.add_dependency('pg', '>=0.10.1')
  gem.add_dependency('haml', '>=3.0.25')
  gem.add_dependency('spatial_adapter', '>=1.2.0')
  gem.add_dependency('wristband', '>=1.0.0')
end
Jeweler::RubygemsDotOrgTasks.new
