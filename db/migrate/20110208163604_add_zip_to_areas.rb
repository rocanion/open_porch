class AddZipToAreas < ActiveRecord::Migration
  def self.up
    add_column :areas, :zip, :string
    remove_column :areas, :last_issue_number
  end

  def self.down
    remove_column :areas, :zip
    # add_column :areas, :last_issue_number, :integer
  end
end
