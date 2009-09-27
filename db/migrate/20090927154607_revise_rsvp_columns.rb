class ReviseRsvpColumns < ActiveRecord::Migration
  
  def self.up
    change_column :rsvps, :likelyhood, :integer, :default => 2, :allow_null => false
  end

  def self.down
  end
  
end
