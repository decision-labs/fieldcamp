class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.integer :user_id
      t.integer :location_id
      t.string :language
      t.timestamps
    end
    add_index :settings, :location_id
    add_index :settings, :language
  end

  def self.down
    remove_index :settings, :language
    remove_index :settings, :location_id
    drop_table :settings
  end
end