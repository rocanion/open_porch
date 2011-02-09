class CreateUserActivities < ActiveRecord::Migration
  def self.up
    create_table :user_activities do |t|
      t.string :url
      t.string :name
      t.datetime :expires_at
    end
  end

  def self.down
    drop_table :user_activities
  end
end
