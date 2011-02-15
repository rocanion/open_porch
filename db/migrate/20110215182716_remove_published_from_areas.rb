require File.expand_path('db/migrate/20110204173301_add_published_to_areas.rb', Rails.root)

class RemovePublishedFromAreas < ActiveRecord::Migration
  def self.up
    AddPublishedToAreas.down
  end

  def self.down
    AddPublishedToAreas.up
  end
end
