class CreateAreaSequences < ActiveRecord::Migration
  def self.up
    create_table :area_sequences do |t|
      t.integer :area_id
      t.integer :sequence_number
    end
    add_index :area_sequences, :id
    execute "ALTER TABLE area_sequences ADD CONSTRAINT check_unique_area_id UNIQUE (area_id)"  
  end
  
  def self.down
    drop_table :area_sequences
  end
end
