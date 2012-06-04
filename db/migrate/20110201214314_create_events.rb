class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string  :title
      t.text    :description
      t.point   :geom, :srid => 4326, :has_z => true
      t.string  :address
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
