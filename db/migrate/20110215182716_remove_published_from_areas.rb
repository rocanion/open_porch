class RemovePublishedFromAreas < ActiveRecord::Migration
  def self.up
    remove_column :areas, :published
  end

  def self.down
    add_column :areas, :published, :boolean, :default => false, :null => false
    add_index :areas, :published
  end
end
