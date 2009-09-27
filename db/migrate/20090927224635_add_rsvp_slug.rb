class AddRsvpSlug < ActiveRecord::Migration
  
  def self.up
    add_column :rsvps, :slug, :string, :length => 32
  end

  def self.down
    remove_column :rsvps, :slug
  end
  
end
