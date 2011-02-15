class AddEmailValidationKeyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email_verification_key, :string
    add_column :users, :verified_at, :datetime
    add_index :users, [:email_verification_key]
    add_index :users, [:verified_at]
  end

  def self.down
    remove_column :users, :email_verification_key
    remove_column :users, :verified_at
  end
end
