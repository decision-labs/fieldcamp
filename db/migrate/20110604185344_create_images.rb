class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :asset
      t.string :title
      t.integer :event_id

      t.timestamps
    end

    add_index :images, [:title]
    add_index :images, [:asset]
  end

  def self.down
    remove_index :images, :column => [:asset]
    remove_index :images, :column => [:title]
    drop_table :images
  end
end
