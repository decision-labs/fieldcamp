class AddProjectsCount < ActiveRecord::Migration
  def self.up
    add_column :locations, :projects_count, :integer, :default => 0
    Location.reset_column_information
    Location.all.each do |l|
      l.update_attribute :projects_count, l.projects.length
    end
  end

  def self.down
    remove_column :locations, :projects_count
  end
end