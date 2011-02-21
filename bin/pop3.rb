#!/usr/bin/env ruby
require "rubygems"
require 'bundler'
require 'net/pop'
require 'yaml'
require 'logger'
require 'iconv'

Bundler.setup
Bundler.require(:pop3)

# ======= Initialize =============================================================

# Request a lock on a file to make sure only one instance of this scrip is running
LOCK_FILE = File.expand_path('../tmp/pids/open_porch.lock', File.dirname(__FILE__))
fh = File.open(LOCK_FILE, File::RDWR|File::CREAT)
unless fh.flock(File::LOCK_EX|File::LOCK_NB)
  puts 'Already running. Bye!'
  fh.close
  exit(0) 
end


# Set default environment
RAILS_ENV = (ENV['RAILS_ENV'] || 'development').dup unless defined?(RAILS_ENV)


# Establish a database connection
db_file = File.expand_path('../config/database.yml', File.dirname(__FILE__))
db_config = YAML::load(File.open(db_file))[RAILS_ENV]
ActiveRecord::Base.establish_connection(db_config)


# Setup logging
log_file = File.expand_path("../log/pop3_#{RAILS_ENV}.log", File.dirname(__FILE__))
ActiveRecord::Base.logger = Logger.new(log_file)


# Load models
require File.expand_path("../config/initializers/email_regex.rb", File.dirname(__FILE__))
%w{email_message area post issue issue_number user membership}.each do |model|
  require File.expand_path("../app/models/#{model}.rb", File.dirname(__FILE__))
end

# Load ActionMailer configuration
require File.expand_path("../config/initializers/setup_mail.rb", File.dirname(__FILE__))

# Load user mailer
ActionMailer::Base.view_paths = File.expand_path("../app/views", File.dirname(__FILE__))
require File.expand_path("../app/mailers/user_mailer.rb", File.dirname(__FILE__))

# Load the pop3 server configuration
pop3_file = File.expand_path('../config/pop3.yml', File.dirname(__FILE__))
pop3_config = YAML::load(File.open(pop3_file))[RAILS_ENV]


# ======= Main =============================================================

# Send all scheduled issues
Issue.scheduled_before(Time.now).each do |issue|
  issue.send!
end

# Parse all new messages from POP3 serevr
EmailMessage.create_from_pop3(pop3_config)


# ======= Cleanup =============================================================

# Release lock
fh.flock(File::LOCK_UN)
fh.close
  