class CreateRsvps < ActiveRecord::Migration
  
  def self.up
    create_table :rsvps do |t|
      t.string  :name, :email, :company
      t.integer :attendees, :likelyhood
      t.boolean :reserved, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :rsvps
  end
  
end
