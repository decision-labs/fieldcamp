class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :file
      t.string :title

      t.timestamps
    end

    add_index :images, [:title]
    add_index :images, [:file]
  end

  def self.down
    remove_index :images, :column => [:file]
    remove_index :images, :column => [:title]
    drop_table :images
  end
end
