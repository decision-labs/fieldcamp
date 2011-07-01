class AddAttributesToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :published, :boolean
    add_column :articles, :title, :string
    add_column :articles, :project_id, :integer

    add_index :articles, :title
    add_index :articles, :project_id
  end

  def self.down
    remove_index :articles, :project_id
    remove_index :articles, :title

    remove_column :articles, :project_id
    remove_column :articles, :title
    remove_column :articles, :published
  end
end