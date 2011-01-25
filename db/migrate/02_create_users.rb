class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :password_hash, :limit => 40
      t.string :password_salt,  :limit => 40
      t.string :perishable_token
      t.string :remember_token
      t.string :role
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip      
      t.timestamps
    end
    add_index :users, :email
    add_index :users, :perishable_token
    add_index :users, :remember_token
  end

  def self.down
    drop_table :users
  end
end
