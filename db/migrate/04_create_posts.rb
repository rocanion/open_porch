class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :area_id
      t.integer :user_id
      t.string  :title
      t.text    :content
      t.timestamps
    end
    add_index :posts, [:area_id, :created_at]
  end

  def self.down
    drop_table :posts
  end
end
