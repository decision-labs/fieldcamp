class AddProjectIdToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :project_id, :integer
    add_index :articles, [:project_id] #, :unique => true
  end

  def self.down
    remove_index :articles, :column => [:project_id]
    remove_column :articles, :project_id
  end
end
