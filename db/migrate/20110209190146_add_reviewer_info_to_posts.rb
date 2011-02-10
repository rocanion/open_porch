class AddReviewerInfoToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :reviewed_by, :string
  end

  def self.down
    remove_column :posts, :reviewed_by
  end
end
