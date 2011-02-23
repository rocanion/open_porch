class DenormalizeUserInfoInPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :user_first_name,  :string
    add_column :posts, :user_last_name,   :string
    add_column :posts, :user_email,       :string
    add_column :posts, :user_address,     :string
    add_column :posts, :user_city,        :string
    add_column :posts, :user_state,       :string
  end

  def self.down
    remove_column :posts, :user_first_name
    remove_column :posts, :user_last_name
    remove_column :posts, :user_email
    remove_column :posts, :user_address
    remove_column :posts, :user_city
    remove_column :posts, :user_state
  end
end