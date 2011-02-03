class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :area_id
      t.integer :user_id
      t.integer :issue_id
      t.integer :parent_id
      t.string  :title
      t.text    :content
      t.integer :position
      t.timestamps
    end
    add_index :posts, [:area_id, :created_at]
    add_index :posts, [:area_id, :issue_id]
  end

  def self.down
    drop_table :posts
  end
end
