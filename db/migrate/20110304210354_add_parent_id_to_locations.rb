class AddParentIdToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :parent_id, :integer
    add_index :locations, :parent_id
  end

  def self.down
    remove_index :locations, :parent_id
    remove_column :locations, :parent_id
  end
end