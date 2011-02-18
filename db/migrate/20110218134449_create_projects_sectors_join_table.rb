class CreateProjectsSectorsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :projects_sectors, :id => false do |t|
      t.integer :project_id
      t.integer :sector_id
    end
  end

  def self.down
    drop_table :projects_sectors
  end
end