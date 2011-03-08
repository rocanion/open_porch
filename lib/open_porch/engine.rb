require 'haml'
require "wristband"
require 'active_link_to'
require 'postageapp'
require 'spatial_adapter'
require "open_porch"
require "formatted_form"
require "will_paginate"
require "meta_search"
require 'geokit'
require "rails"

module OpenPorch
  class Engine < Rails::Engine
    initializer 'open_porch_helper' do |app|
      require File.expand_path("../../app/helpers/open_porch_helper.rb", File.dirname(__FILE__))
      ActionView::Base.send(:include, OpenPorchHelper)
    end
  end
end