class CreateAreaActivities < ActiveRecord::Migration
  def self.up
    create_table :area_activities do |t|
      t.integer   :area_id
      t.date      :day
      t.integer   :quitters_count,          :default => 0
      t.integer   :new_users_count,         :default => 0
      t.integer   :new_posts_count,         :default => 0
      t.integer   :issues_published_count,  :default => 0
      t.timestamps
    end
    add_index :area_activities, :area_id
    add_index :area_activities, :day
  end

  def self.down
    drop_table :area_activities
  end
end
