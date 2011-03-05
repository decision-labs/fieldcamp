class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string    :name
      t.text      :description
      t.integer   :admin_level
      t.geometry  :geom, :srid => 4326, :with_z => false, :null => false

      t.timestamps
    end
    add_index :locations, :geom, :spatial => true
  end

  def self.down
    remove_index :locations, :geom
    drop_table :locations
  end
end