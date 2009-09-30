class RemoveLikelyhood < ActiveRecord::Migration
  
  def self.up
    remove_column :rsvps, :likelyhood
  end

  def self.down
    add_column :rsvps, :likelyhood, :integer, :default => 2
  end
  
end
