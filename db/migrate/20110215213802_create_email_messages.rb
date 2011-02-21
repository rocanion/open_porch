class CreateEmailMessages < ActiveRecord::Migration
  def self.up
    create_table :email_messages do |t|
      t.integer :number
      t.text :content
      t.integer :size
      t.boolean :parsed, :default => false, :null => false
      t.timestamps
    end
    add_index :email_messages, [:parsed]
    
    add_column :posts, :email_message_id, :integer
  end

  def self.down
    drop_table :email_messages
    remove_column :posts, :email_message_id
  end
end
