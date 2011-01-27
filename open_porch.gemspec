# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{open_porch}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["The Working Group Inc"]
  s.date = %q{2011-01-27}
  s.description = %q{}
  s.email = %q{jack@theworkinggroup.ca}
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "README.md",
    "Rakefile",
    "VERSION",
    "app/controllers/admin/areas_controller.rb",
    "app/controllers/admin/base_controller.rb",
    "app/controllers/admin/users_controller.rb",
    "app/controllers/application_controller.rb",
    "app/controllers/areas_controller.rb",
    "app/controllers/passwords_controller.rb",
    "app/controllers/registrations_controller.rb",
    "app/controllers/sessions_controller.rb",
    "app/controllers/users_controller.rb",
    "app/helpers/application_helper.rb",
    "app/helpers/areas_helper.rb",
    "app/mailers/user_mailer.rb",
    "app/models/address.rb",
    "app/models/area.rb",
    "app/models/membership.rb",
    "app/models/session_user.rb",
    "app/models/user.rb",
    "app/views/admin/areas/_form.html.haml",
    "app/views/admin/areas/edit.html.haml",
    "app/views/admin/areas/index.html.haml",
    "app/views/admin/areas/new.html.haml",
    "app/views/admin/users/_form.html.haml",
    "app/views/admin/users/edit.html.haml",
    "app/views/admin/users/index.html.haml",
    "app/views/areas/index.html.haml",
    "app/views/layouts/_flash_message.html.haml",
    "app/views/layouts/_footer.html.haml",
    "app/views/layouts/_head.html.haml",
    "app/views/layouts/_header.html.haml",
    "app/views/layouts/admin.html.haml",
    "app/views/layouts/admin/_header.html.haml",
    "app/views/layouts/application.html.haml",
    "app/views/passwords/edit.html.haml",
    "app/views/passwords/new.html.haml",
    "app/views/registrations/_address_form.html.haml",
    "app/views/registrations/create.html.haml",
    "app/views/registrations/index.html.haml",
    "app/views/registrations/new.html.haml",
    "app/views/sessions/new.html.haml",
    "app/views/stylesheets/common.sass",
    "app/views/stylesheets/content.sass",
    "app/views/stylesheets/reset.sass",
    "app/views/stylesheets/structure.sass",
    "app/views/stylesheets/typography.sass",
    "app/views/user_mailer/password_reset.html.haml",
    "app/views/user_mailer/password_reset.text.haml",
    "app/views/users/_form.html.haml",
    "app/views/users/new.html.haml",
    "app/views/users/show.html.haml",
    "config.ru",
    "config/application.rb",
    "config/boot.rb",
    "config/database_example.yml",
    "config/environment.rb",
    "config/environments/development.rb",
    "config/environments/production.rb",
    "config/environments/test.rb",
    "config/initializers/backtrace_silencers.rb",
    "config/initializers/geokit_config.rb",
    "config/initializers/inflections.rb",
    "config/initializers/mime_types.rb",
    "config/initializers/sass.rb",
    "config/initializers/secret_token.rb",
    "config/initializers/session_store.rb",
    "config/initializers/states_provinces.rb",
    "config/locales/en.yml",
    "config/routes.rb",
    "db/migrate/01_create_areas.rb",
    "db/migrate/02_create_users.rb",
    "db/migrate/03_create_memberships.rb",
    "db/seeds.rb",
    "doc/README_FOR_APP",
    "lib/generators/open_porch_generator.rb",
    "lib/open_porch.rb",
    "lib/open_porch/engine.rb",
    "lib/tasks/.gitkeep",
    "lib/tasks/rcov.rake",
    "open_porch.gemspec",
    "public/404.html",
    "public/422.html",
    "public/500.html",
    "public/favicon.ico",
    "public/javascripts/application.js",
    "public/javascripts/google_maps.js",
    "public/javascripts/jquery.js",
    "public/javascripts/rails.js",
    "public/robots.txt",
    "script/rails",
    "test/dummy/area.rb",
    "test/dummy/membership.rb",
    "test/dummy/user.rb",
    "test/functional/admin/areas_controller_test.rb",
    "test/functional/admin/base_controller_test.rb",
    "test/functional/admin/users_controller_test.rb",
    "test/functional/areas_controller_test.rb",
    "test/functional/passwords_controller_test.rb",
    "test/functional/registrations_controller_test.rb",
    "test/functional/sessions_controller_test.rb",
    "test/functional/users_controller_test.rb",
    "test/performance/browsing_test.rb",
    "test/test_helper.rb",
    "test/unit/address_test.rb",
    "test/unit/area_test.rb",
    "test/unit/helpers/areas_helper_test.rb",
    "test/unit/helpers/registrations_helper_test.rb",
    "test/unit/membership_test.rb",
    "test/unit/session_user_test.rb",
    "test/unit/user_mailer_test.rb",
    "test/unit/user_test.rb",
    "vendor/plugins/.gitkeep"
  ]
  s.homepage = %q{http://github.com/FrontPorchForum/open_porch}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Open Porch is Rails Engine}
  s.test_files = [
    "test/dummy/area.rb",
    "test/dummy/membership.rb",
    "test/dummy/user.rb",
    "test/functional/admin/areas_controller_test.rb",
    "test/functional/admin/base_controller_test.rb",
    "test/functional/admin/users_controller_test.rb",
    "test/functional/areas_controller_test.rb",
    "test/functional/passwords_controller_test.rb",
    "test/functional/registrations_controller_test.rb",
    "test/functional/sessions_controller_test.rb",
    "test/functional/users_controller_test.rb",
    "test/performance/browsing_test.rb",
    "test/test_helper.rb",
    "test/unit/address_test.rb",
    "test/unit/area_test.rb",
    "test/unit/helpers/areas_helper_test.rb",
    "test/unit/helpers/registrations_helper_test.rb",
    "test/unit/membership_test.rb",
    "test/unit/session_user_test.rb",
    "test/unit/user_mailer_test.rb",
    "test/unit/user_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["= 3.0.3"])
      s.add_runtime_dependency(%q<pg>, ["= 0.10.1"])
      s.add_runtime_dependency(%q<haml>, ["= 3.0.25"])
      s.add_runtime_dependency(%q<spatial_adapter>, ["= 1.2.0"])
      s.add_runtime_dependency(%q<wristband>, ["= 1.0.2"])
      s.add_runtime_dependency(%q<formatted_form>, [">= 0"])
      s.add_runtime_dependency(%q<geokit>, ["= 1.5.0"])
      s.add_runtime_dependency(%q<rails>, ["= 3.0.3"])
      s.add_runtime_dependency(%q<pg>, ["= 0.10.1"])
      s.add_runtime_dependency(%q<haml>, ["= 3.0.25"])
      s.add_runtime_dependency(%q<spatial_adapter>, ["= 1.2.0"])
      s.add_runtime_dependency(%q<wristband>, ["= 1.0.2"])
      s.add_runtime_dependency(%q<geokit>, ["= 1.5.0"])
    else
      s.add_dependency(%q<rails>, ["= 3.0.3"])
      s.add_dependency(%q<pg>, ["= 0.10.1"])
      s.add_dependency(%q<haml>, ["= 3.0.25"])
      s.add_dependency(%q<spatial_adapter>, ["= 1.2.0"])
      s.add_dependency(%q<wristband>, ["= 1.0.2"])
      s.add_dependency(%q<formatted_form>, [">= 0"])
      s.add_dependency(%q<geokit>, ["= 1.5.0"])
      s.add_dependency(%q<rails>, ["= 3.0.3"])
      s.add_dependency(%q<pg>, ["= 0.10.1"])
      s.add_dependency(%q<haml>, ["= 3.0.25"])
      s.add_dependency(%q<spatial_adapter>, ["= 1.2.0"])
      s.add_dependency(%q<wristband>, ["= 1.0.2"])
      s.add_dependency(%q<geokit>, ["= 1.5.0"])
    end
  else
    s.add_dependency(%q<rails>, ["= 3.0.3"])
    s.add_dependency(%q<pg>, ["= 0.10.1"])
    s.add_dependency(%q<haml>, ["= 3.0.25"])
    s.add_dependency(%q<spatial_adapter>, ["= 1.2.0"])
    s.add_dependency(%q<wristband>, ["= 1.0.2"])
    s.add_dependency(%q<formatted_form>, [">= 0"])
    s.add_dependency(%q<geokit>, ["= 1.5.0"])
    s.add_dependency(%q<rails>, ["= 3.0.3"])
    s.add_dependency(%q<pg>, ["= 0.10.1"])
    s.add_dependency(%q<haml>, ["= 3.0.25"])
    s.add_dependency(%q<spatial_adapter>, ["= 1.2.0"])
    s.add_dependency(%q<wristband>, ["= 1.0.2"])
    s.add_dependency(%q<geokit>, ["= 1.5.0"])
  end
end

