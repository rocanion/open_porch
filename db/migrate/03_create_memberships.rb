class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :area_id
      t.timestamps
    end
    add_index :memberships, [:user_id, :area_id]
  end

  def self.down
    drop_table :memberships
  end
end
