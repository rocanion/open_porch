# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{open_porch}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["The Working Group Inc"]
  s.date = %q{2011-02-24}
  s.default_executable = %q{open_porch_engine}
  s.description = %q{}
  s.email = %q{jack@theworkinggroup.ca}
  s.executables = ["open_porch_engine"]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "README.md",
    "Rakefile",
    "VERSION",
    "app/controllers/admin/areas/base_controller.rb",
    "app/controllers/admin/areas/issues_controller.rb",
    "app/controllers/admin/areas/memberships_controller.rb",
    "app/controllers/admin/areas/posts_controller.rb",
    "app/controllers/admin/areas_controller.rb",
    "app/controllers/admin/base_controller.rb",
    "app/controllers/admin/user_activity_controller.rb",
    "app/controllers/admin/users_controller.rb",
    "app/controllers/application_controller.rb",
    "app/controllers/areas/base_controller.rb",
    "app/controllers/areas/issues_controller.rb",
    "app/controllers/areas/posts_controller.rb",
    "app/controllers/areas_controller.rb",
    "app/controllers/passwords_controller.rb",
    "app/controllers/registrations_controller.rb",
    "app/controllers/sessions_controller.rb",
    "app/controllers/users_controller.rb",
    "app/helpers/open_porch_helper.rb",
    "app/mailers/user_mailer.rb",
    "app/models/address.rb",
    "app/models/area.rb",
    "app/models/area_activity.rb",
    "app/models/email_message.rb",
    "app/models/issue.rb",
    "app/models/issue_number.rb",
    "app/models/membership.rb",
    "app/models/post.rb",
    "app/models/session_user.rb",
    "app/models/user.rb",
    "app/models/user_activity.rb",
    "app/models/user_authority_check.rb",
    "app/views/admin/areas/_form.html.haml",
    "app/views/admin/areas/_nav.html.haml",
    "app/views/admin/areas/edit.html.haml",
    "app/views/admin/areas/edit_borders.html.haml",
    "app/views/admin/areas/index.html.haml",
    "app/views/admin/areas/issues/_post.html.haml",
    "app/views/admin/areas/issues/add_posts.js.rjs",
    "app/views/admin/areas/issues/edit.html.haml",
    "app/views/admin/areas/issues/index.html.haml",
    "app/views/admin/areas/issues/remove_posts.js.rjs",
    "app/views/admin/areas/issues/show.html.haml",
    "app/views/admin/areas/memberships/index.html.haml",
    "app/views/admin/areas/new.html.haml",
    "app/views/admin/areas/new.js.haml",
    "app/views/admin/areas/posts/_edit.html.haml",
    "app/views/admin/areas/posts/_post_status.html.haml",
    "app/views/admin/areas/posts/destroy.js.rjs",
    "app/views/admin/areas/posts/edit.js.rjs",
    "app/views/admin/areas/posts/show.js.rjs",
    "app/views/admin/areas/posts/toggle_reviewed_by.js.rjs",
    "app/views/admin/areas/posts/update.js.rjs",
    "app/views/admin/areas/show.html.haml",
    "app/views/admin/user_activity/show.html.haml",
    "app/views/admin/users/_form.html.haml",
    "app/views/admin/users/edit.html.haml",
    "app/views/admin/users/index.html.haml",
    "app/views/admin/users/new.html.haml",
    "app/views/areas/issues/index.html.haml",
    "app/views/areas/issues/show.html.haml",
    "app/views/areas/posts/_post.html.haml",
    "app/views/areas/posts/_posts_search_form.html.haml",
    "app/views/areas/posts/index.html.haml",
    "app/views/areas/posts/new.html.haml",
    "app/views/areas/show.html.haml",
    "app/views/layouts/_account_nav.html.haml",
    "app/views/layouts/_flash_message.html.haml",
    "app/views/layouts/_footer.html.haml",
    "app/views/layouts/_head.html.haml",
    "app/views/layouts/admin.html.haml",
    "app/views/layouts/admin/_nav.html.haml",
    "app/views/layouts/application.html.haml",
    "app/views/layouts/area_editor.html.haml",
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
    "app/views/user_mailer/email_verification.html.erb",
    "app/views/user_mailer/email_verification.text.erb",
    "app/views/user_mailer/new_issue.html.erb",
    "app/views/user_mailer/new_issue.text.erb",
    "app/views/user_mailer/password_reset.html.erb",
    "app/views/user_mailer/password_reset.text.erb",
    "app/views/users/_form.html.haml",
    "app/views/users/edit.html.haml",
    "app/views/users/new.html.haml",
    "app/views/users/show.html.haml",
    "bin/open_porch_engine",
    "config.ru",
    "config/application.rb",
    "config/boot.rb",
    "config/database_example.yml",
    "config/environment.rb",
    "config/environments/development.rb",
    "config/environments/production.rb",
    "config/environments/test.rb",
    "config/initializers/backtrace_silencers.rb",
    "config/initializers/email_regex.rb",
    "config/initializers/geokit_config.rb",
    "config/initializers/inflections.rb",
    "config/initializers/meta_search.rb",
    "config/initializers/mime_types.rb",
    "config/initializers/open_porch.rb",
    "config/initializers/sass.rb",
    "config/initializers/secret_token.rb",
    "config/initializers/session_store.rb",
    "config/initializers/states_provinces.rb",
    "config/initializers/will_paginate.rb",
    "config/locales/en.yml",
    "config/open_porch_example.yml",
    "config/routes.rb",
    "config/schedule.rb",
    "db/migrate/01_create_areas.rb",
    "db/migrate/02_create_users.rb",
    "db/migrate/03_create_memberships.rb",
    "db/migrate/04_create_posts.rb",
    "db/migrate/05_create_issue_numbers.rb",
    "db/migrate/06_create_issues.rb",
    "db/migrate/20110204173301_add_published_to_areas.rb",
    "db/migrate/20110204194840_create_user_activities.rb",
    "db/migrate/20110208163604_add_zip_to_areas.rb",
    "db/migrate/20110209175723_add_counters_to_areas.rb",
    "db/migrate/20110209182244_remove_subject_from_issues.rb",
    "db/migrate/20110209190146_add_reviewer_info_to_posts.rb",
    "db/migrate/20110215173144_add_email_validation_key_to_users.rb",
    "db/migrate/20110215182716_remove_published_from_areas.rb",
    "db/migrate/20110215211012_create_area_activities.rb",
    "db/migrate/20110215213802_create_email_messages.rb",
    "db/migrate/20110217165018_change_send_mode_to_string.rb",
    "db/migrate/20110223160609_denormalize_user_info_in_posts.rb",
    "db/seeds.rb",
    "doc/README_FOR_APP",
    "lib/generators/open_porch_generator.rb",
    "lib/open_porch.rb",
    "lib/open_porch/engine.rb",
    "lib/tasks/.gitkeep",
    "lib/tasks/open_porch.rake",
    "lib/tasks/postageapp_tasks.rake",
    "open_porch.gemspec",
    "public/404.html",
    "public/422.html",
    "public/500.html",
    "public/favicon.ico",
    "public/images/icons/ajax-loader.gif",
    "public/images/icons/calendar.png",
    "public/images/icons/post_new.png",
    "public/images/icons/post_reviewed.png",
    "public/javascripts/application.js",
    "public/javascripts/google_maps.js",
    "public/javascripts/highcharts.js",
    "public/javascripts/highcharts_init.js",
    "public/javascripts/issue_edit.js",
    "public/javascripts/jquery-ui.min.js",
    "public/javascripts/jquery.js",
    "public/javascripts/rails.js",
    "public/javascripts/region_editor.js",
    "public/javascripts/user_activity.js",
    "public/robots.txt",
    "public/stylesheets/images/ui-bg_flat_0_aaaaaa_40x100.png",
    "public/stylesheets/images/ui-bg_flat_75_ffffff_40x100.png",
    "public/stylesheets/images/ui-bg_glass_55_fbf9ee_1x400.png",
    "public/stylesheets/images/ui-bg_glass_65_ffffff_1x400.png",
    "public/stylesheets/images/ui-bg_glass_75_dadada_1x400.png",
    "public/stylesheets/images/ui-bg_glass_75_e6e6e6_1x400.png",
    "public/stylesheets/images/ui-bg_glass_95_fef1ec_1x400.png",
    "public/stylesheets/images/ui-bg_highlight-soft_75_cccccc_1x100.png",
    "public/stylesheets/images/ui-icons_222222_256x240.png",
    "public/stylesheets/images/ui-icons_2e83ff_256x240.png",
    "public/stylesheets/images/ui-icons_454545_256x240.png",
    "public/stylesheets/images/ui-icons_888888_256x240.png",
    "public/stylesheets/images/ui-icons_cd0a0a_256x240.png",
    "public/stylesheets/jquery-ui.css",
    "script/rails",
    "test/dummy/area.rb",
    "test/dummy/area_activity.rb",
    "test/dummy/issue.rb",
    "test/dummy/membership.rb",
    "test/dummy/post.rb",
    "test/dummy/user.rb",
    "test/dummy/user_activity.rb",
    "test/functional/admin/areas/issues_controller_test.rb",
    "test/functional/admin/areas/memberships_controller_test.rb",
    "test/functional/admin/areas/posts_controller_test.rb",
    "test/functional/admin/areas_controller_test.rb",
    "test/functional/admin/base_controller_test.rb",
    "test/functional/admin/user_activity_controller_test.rb",
    "test/functional/admin/users_controller_test.rb",
    "test/functional/areas/issues_controller_test.rb",
    "test/functional/areas/posts_controller_test.rb",
    "test/functional/areas_controller_test.rb",
    "test/functional/passwords_controller_test.rb",
    "test/functional/registrations_controller_test.rb",
    "test/functional/sessions_controller_test.rb",
    "test/functional/users_controller_test.rb",
    "test/performance/browsing_test.rb",
    "test/test_helper.rb",
    "test/unit/address_test.rb",
    "test/unit/area_activity_test.rb",
    "test/unit/area_test.rb",
    "test/unit/email_message_test.rb",
    "test/unit/issue_number_test.rb",
    "test/unit/issue_test.rb",
    "test/unit/membership_test.rb",
    "test/unit/post_test.rb",
    "test/unit/session_user_test.rb",
    "test/unit/user_activity_test.rb",
    "test/unit/user_mailer_test.rb",
    "test/unit/user_test.rb",
    "vendor/plugins/.gitkeep"
  ]
  s.homepage = %q{http://github.com/FrontPorchForum/open_porch}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Open Porch is Rails Engine}
  s.test_files = [
    "test/dummy/area.rb",
    "test/dummy/area_activity.rb",
    "test/dummy/issue.rb",
    "test/dummy/membership.rb",
    "test/dummy/post.rb",
    "test/dummy/user.rb",
    "test/dummy/user_activity.rb",
    "test/functional/admin/areas/issues_controller_test.rb",
    "test/functional/admin/areas/memberships_controller_test.rb",
    "test/functional/admin/areas/posts_controller_test.rb",
    "test/functional/admin/areas_controller_test.rb",
    "test/functional/admin/base_controller_test.rb",
    "test/functional/admin/user_activity_controller_test.rb",
    "test/functional/admin/users_controller_test.rb",
    "test/functional/areas/issues_controller_test.rb",
    "test/functional/areas/posts_controller_test.rb",
    "test/functional/areas_controller_test.rb",
    "test/functional/passwords_controller_test.rb",
    "test/functional/registrations_controller_test.rb",
    "test/functional/sessions_controller_test.rb",
    "test/functional/users_controller_test.rb",
    "test/performance/browsing_test.rb",
    "test/test_helper.rb",
    "test/unit/address_test.rb",
    "test/unit/area_activity_test.rb",
    "test/unit/area_test.rb",
    "test/unit/email_message_test.rb",
    "test/unit/issue_number_test.rb",
    "test/unit/issue_test.rb",
    "test/unit/membership_test.rb",
    "test/unit/post_test.rb",
    "test/unit/session_user_test.rb",
    "test/unit/user_activity_test.rb",
    "test/unit/user_mailer_test.rb",
    "test/unit/user_test.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["= 3.0.4"])
      s.add_runtime_dependency(%q<pg>, ["= 0.10.1"])
      s.add_runtime_dependency(%q<haml>, ["= 3.0.25"])
      s.add_runtime_dependency(%q<spatial_adapter>, ["= 1.2.0"])
      s.add_runtime_dependency(%q<wristband>, [">= 1.0.4"])
      s.add_runtime_dependency(%q<formatted_form>, [">= 1.0.1"])
      s.add_runtime_dependency(%q<geokit>, ["= 1.5.0"])
      s.add_runtime_dependency(%q<active_link_to>, ["= 0.0.6"])
      s.add_runtime_dependency(%q<meta_where>, ["= 1.0.1"])
      s.add_runtime_dependency(%q<meta_search>, ["= 1.0.1"])
      s.add_runtime_dependency(%q<will_paginate>, ["~> 3.0.pre2"])
      s.add_runtime_dependency(%q<whenever>, ["= 0.6.2"])
      s.add_runtime_dependency(%q<postageapp>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["= 3.0.4"])
      s.add_dependency(%q<pg>, ["= 0.10.1"])
      s.add_dependency(%q<haml>, ["= 3.0.25"])
      s.add_dependency(%q<spatial_adapter>, ["= 1.2.0"])
      s.add_dependency(%q<wristband>, [">= 1.0.4"])
      s.add_dependency(%q<formatted_form>, [">= 1.0.1"])
      s.add_dependency(%q<geokit>, ["= 1.5.0"])
      s.add_dependency(%q<active_link_to>, ["= 0.0.6"])
      s.add_dependency(%q<meta_where>, ["= 1.0.1"])
      s.add_dependency(%q<meta_search>, ["= 1.0.1"])
      s.add_dependency(%q<will_paginate>, ["~> 3.0.pre2"])
      s.add_dependency(%q<whenever>, ["= 0.6.2"])
      s.add_dependency(%q<postageapp>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["= 3.0.4"])
    s.add_dependency(%q<pg>, ["= 0.10.1"])
    s.add_dependency(%q<haml>, ["= 3.0.25"])
    s.add_dependency(%q<spatial_adapter>, ["= 1.2.0"])
    s.add_dependency(%q<wristband>, [">= 1.0.4"])
    s.add_dependency(%q<formatted_form>, [">= 1.0.1"])
    s.add_dependency(%q<geokit>, ["= 1.5.0"])
    s.add_dependency(%q<active_link_to>, ["= 0.0.6"])
    s.add_dependency(%q<meta_where>, ["= 1.0.1"])
    s.add_dependency(%q<meta_search>, ["= 1.0.1"])
    s.add_dependency(%q<will_paginate>, ["~> 3.0.pre2"])
    s.add_dependency(%q<whenever>, ["= 0.6.2"])
    s.add_dependency(%q<postageapp>, [">= 0"])
  end
end

