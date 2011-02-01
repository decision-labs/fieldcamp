class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string  :title
      t.text    :description
      t.point   :geom, :srid => 4326, :with_z => true
      t.integer :project_id

      t.timestamps
    end
    add_index :events, :geom, :spatial => true
  end

  def self.down
    remove_index :events, :geom
    drop_table :events
  end
end