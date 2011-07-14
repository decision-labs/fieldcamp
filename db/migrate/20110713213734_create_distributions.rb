class CreateDistributions < ActiveRecord::Migration
  def self.up
    create_table :distributions do |t|
      t.string :item
      t.integer :quantity_of_items
      t.string :unit
      t.string :recipient
      t.integer :number_of_recipients
      t.integer :event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :distributions
  end
end
