class AddChildLocationIdsToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :child_location_ids, :text
  end

  def self.down
    remove_column :locations, :child_location_ids
  end
end
