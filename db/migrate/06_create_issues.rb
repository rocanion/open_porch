class CreateIssues < ActiveRecord::Migration
  def self.up
    create_table :issues do |t|
      t.string    :subject
      t.integer   :area_id
      t.datetime  :scheduled_at
      t.datetime  :sent_at
      t.integer   :number
      t.timestamps
    end
    add_index :issues, :area_id
    add_index :issues, [:area_id, :scheduled_at]
    add_index :issues, [:area_id, :sent_at]
    add_index :issues, :number
    add_index :issues, [:area_id, :number]
  end

  def self.down
    drop_table :issues
  end
end
