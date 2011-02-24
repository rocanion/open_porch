source 'http://rubygems.org'

gem 'rails', '3.0.4'
gem 'pg', '0.10.1' # See installation notes below
gem 'haml', '3.0.25'
gem 'spatial_adapter', '1.2.0', :require => 'spatial_adapter/postgresql'
gem 'wristband', '>= 1.0.4'
gem 'formatted_form', '>= 1.0.1'
gem 'geokit', '1.5.0'
gem 'active_link_to', '0.0.6'
gem "meta_where", '1.0.1'
gem "meta_search", '1.0.1'
gem "will_paginate", "~> 3.0.pre2"
gem 'whenever', '0.6.2', :require => false
gem 'postageapp'

group :test do
  gem "bundler"
  gem "jeweler"
  gem 'test_dummy'
  gem 'faker'
  gem 'mocha'
end


# Initial postgress configuration: 
# http://www.glom.org/wiki/index.php?title=Initial_Postgres_Configuration



# Installing the pg gem (https://bitbucket.org/ged/ruby-pg/wiki/Home)
# ------------------------------------------------------------------------
# 1 - You need to set the path to 'pg_config' in your PATH (i.e. where your postgres was installed )
#   Example:
#     /Library/PostgreSQL/9.0/bin

# 2 - On Mac you need to specify the achitecture
#   For Snow Leopard 32-bit build use: '-arch i386'
#   For Snow Leopard 64-bit build use: '-arch x86_64'
#   Example:
#     ARCHFLAGS="-arch x86_64" gem install pg