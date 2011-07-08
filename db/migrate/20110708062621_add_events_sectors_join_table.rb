class AddEventsSectorsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :events_sectors, :id => false do |t|
      t.integer :event_id
      t.integer :sector_id
    end
    add_index :events_sectors, :event_id
    add_index :events_sectors, :sector_id
  end

  def self.down
    remove_index :events_sectors, :sector_id
    remove_index :events_sectors, :event_id
    drop_table :events_sectors
  end
end
