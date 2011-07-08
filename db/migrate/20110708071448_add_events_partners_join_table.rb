class AddEventsPartnersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :events_partners, :id => false do |t|
      t.integer :event_id
      t.integer :partner_id
    end
    add_index :events_partners, :event_id
    add_index :events_partners, :partner_id
  end

  def self.down
    remove_index :events_partners, :partner_id
    remove_index :events_partners, :event_id
    drop_table :events_partners
  end
end
