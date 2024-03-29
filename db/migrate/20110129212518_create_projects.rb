class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string  :title, :null => false
      t.text    :description
      t.integer :admin_id
      t.date    :start_date
      t.date    :end_date
      t.integer :location_id

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
