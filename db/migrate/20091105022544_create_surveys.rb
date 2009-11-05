class CreateSurveys < ActiveRecord::Migration
  
  def self.up
    create_table :surveys do |t|
      t.integer :rsvp_id
      t.text :a1t
      t.text :a2t
      t.text :a3t
      t.text :a4t
      t.boolean :a1b
      t.boolean :a2b
      t.timestamps
    end
  end

  def self.down
    drop_table :surveys
  end
  
end
