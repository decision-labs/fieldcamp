class AddProjectsCount < ActiveRecord::Migration
  def self.up
    add_column :locations, :projects_count, :integer, :default => 0
    
    Location.reset_column_information
    Location.find_each do |l|
      Location.reset_counters l.id, :projects
    end
  end

  def self.down
    remove_column :locations, :projects_count
  end
end