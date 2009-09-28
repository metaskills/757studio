class AddAttendeeNames < ActiveRecord::Migration
  
  def self.up
    add_column :rsvps, :attendee_names, :string, :limit => 1024
  end

  def self.down
    remove_column :rsvps, :attendee_names
  end
  
end
