class AddReviewerInfoToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :reviewed_by_id, :integer
  end

  def self.down
    remove_column :posts, :reviewed_by_id
  end
end
