class AddCountersToAreas < ActiveRecord::Migration
  def self.up
    add_column :areas, :memberships_count, :integer
    add_column :areas, :issues_count, :integer
  end

  def self.down
    remove_column :areas, :memberships_count
    remove_column :areas, :issues_count
  end
end
