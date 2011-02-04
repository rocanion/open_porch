class AddPublishedToAreas < ActiveRecord::Migration
  def self.up
    add_column :areas, :published, :boolean, :default => false, :null => false
    add_index :areas, :published
  end

  def self.down
    remove_column :areas, :published
  end
end
