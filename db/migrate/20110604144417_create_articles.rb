class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.text :content
      t.datetime :published_at
      t.integer :author_id

      t.timestamps
    end

    add_index :articles, [:author_id]
    add_index :articles, [:published_at]

  end

  def self.down
    remove_index :articles, :column => [:published_at]
    remove_index :articles, :column => [:author_id]
    drop_table :articles
  end
end
