class DefaultAttendees < ActiveRecord::Migration
  
  def self.up
    change_column :rsvps, :attendees, :integer, :default => 1, :allow_null => false
  end

  def self.down
  end
  
end
