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
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "op #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end