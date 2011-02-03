class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.string :name
      t.text :description
      t.string :city
      t.string :state
      t.string :slug
      t.integer :last_issue_number
      t.integer :households
      t.integer :send_mode, :default => 0
      t.column :border, :polygon, :geographic => true, :srid => 4326
      t.timestamps
    end
    add_index :areas, :border, :spatial => true
  end

  def self.down
    drop_table :areas
  end
end
