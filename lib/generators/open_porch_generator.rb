class OpenPorchGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../../..', __FILE__)
  
  def generate_migration
    destination   = File.expand_path('db/migrate/01_create_open_porch.rb', self.destination_root)
    migration_dir = File.dirname(destination)
    destination   = self.class.migration_exists?(migration_dir, 'create_open_porch')

    if destination
      puts "\e[0m\e[31mFound existing create_open_porch.rb migration. Remove it if you want to regenerate.\e[0m"
    else
      migration_template 'db/migrate/01_create_open_porch.rb', 'db/migrate/create_open_porch.rb'
    end
  end

  def self.next_migration_number(dirname)
    orm = Rails.configuration.generators.options[:rails][:orm]
    require "rails/generators/#{orm}"
    "#{orm.to_s.camelize}::Generators::Base".constantize.next_migration_number(dirname)
  end
end
