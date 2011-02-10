class OpenPorchGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../../..', __FILE__)
  
  def generate_application_controller
    copy_file 'app/controllers/application_controller.rb', 'app/controllers/application_controller.rb'
  end
  
  def generate_static_files
    directory 'app/views/stylesheets', 'app/views/stylesheets'
    directory 'public/javascripts', 'public/javascripts'
    directory 'public/images', 'public/images'
  end

  def generate_migration
    migrations = Dir.glob(File.expand_path('db/migrate/*.rb', self.class.source_root))
    
    migrations.each do |migration|
      filename = File.basename(migration).gsub(/\d+_/, '')
      migration_template migration, "db/migrate/#{filename}"
    end
  end
  
  def self.next_migration_number(dirname)
    orm = Rails.configuration.generators.options[:rails][:orm]
    require "rails/generators/#{orm}"
    "#{orm.to_s.camelize}::Generators::Base".constantize.next_migration_number(dirname)
  end
end
