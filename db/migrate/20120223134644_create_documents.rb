class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :asset
      t.string :title
      t.text :description
      t.integer :event_id

      t.timestamps
    end
    add_index :documents, [:title]
    add_index :documents, [:asset]
  end

  def self.down
    remove_index :documents, :column => [:asset]
    remove_index :documents, :column => [:title]
    drop_table :documents
  end
end
