class AddIso31662ColumnToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :iso_3166_2, :string, :limit => 2
    add_index :locations, :iso_3166_2
  end

  def self.down
    remove_index :locations, :iso_3166_2
    remove_column :locations, :iso_3166_2
  end
end