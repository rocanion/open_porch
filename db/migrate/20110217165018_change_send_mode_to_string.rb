class ChangeSendModeToString < ActiveRecord::Migration
  def self.up
    rename_column :areas, :send_mode, :old_send_mode
    add_column :areas, :send_mode, :string
    Area.update_all({:send_mode => 'immediate'}, 'old_send_mode = 0 OR old_send_mode IS NULL')
    Area.update_all({:send_mode => 'batched'}, {:old_send_mode => 1})
    remove_column :areas, :old_send_mode
  end

  def self.down
    rename_column :areas, :send_mode, :old_send_mode
    add_column :areas, :send_mode, :integer
    Area.update_all({:send_mode => 0}, "old_send_mode = 'immediate' OR old_send_mode IS NULL")
    Area.update_all({:send_mode => 1}, {:old_send_mode => 'batched'})
    remove_column :areas, :old_send_mode
  end
end
