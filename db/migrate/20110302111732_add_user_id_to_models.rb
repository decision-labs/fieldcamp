class AddUserIdToModels < ActiveRecord::Migration
  def self.up
    add_column :projects, :user_id, :integer
    add_column :sectors, :user_id, :integer
    add_column :partners, :user_id, :integer
    add_column :events, :user_id, :integer
    add_column :locations, :user_id, :integer

    add_index :projects, :user_id
    add_index :sectors, :user_id
    add_index :partners, :user_id
    add_index :events, :user_id
    add_index :locations, :user_id
  end

  def self.down
    remove_index :locations, :user_id
    remove_index :events, :user_id
    remove_index :partners, :user_id
    remove_index :sectors, :user_id
    remove_index :projects, :user_id

    remove_column :locations, :user_id
    remove_column :events, :user_id
    remove_column :partners, :user_id
    remove_column :sectors, :user_id
    remove_column :projects, :user_id
  end
end
