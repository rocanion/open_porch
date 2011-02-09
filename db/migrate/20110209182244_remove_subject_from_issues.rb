class RemoveSubjectFromIssues < ActiveRecord::Migration
  def self.up
    remove_column :issues, :subject
  end

  def self.down
    add_column :issues, :subject, :string
  end
end
