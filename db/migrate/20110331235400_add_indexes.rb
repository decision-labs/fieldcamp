class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :projects, :title
    add_index :sectors, :name
    add_index :partners, :name
    add_index :locations, :name
    add_index :events, :title
  end

  def self.down
    remove_index :events, :title
    remove_index :locations, :name
    remove_index :partners, :name
    remove_index :sectors, :name
    remove_index :projects, :title
  end
end