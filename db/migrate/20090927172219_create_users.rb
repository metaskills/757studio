class CreateUsers < ActiveRecord::Migration
  
  def self.up
    create_table :users do |t|
      t.string :email, :password, :allow_null => false
      t.boolean :admin, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
  
end
