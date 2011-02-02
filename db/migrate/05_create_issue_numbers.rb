class CreateIssueNumbers < ActiveRecord::Migration
  def self.up
    create_table :issue_numbers do |t|
      t.integer :area_id
      t.integer :sequence_number
    end
    add_index :issue_numbers, :area_id, :unique => true
  end
  
  def self.down
    drop_table :issue_numbers
  end
end
