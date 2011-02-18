class CreatePartnersProjectsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :partners_projects, :id => false do |t|
      t.integer :partner_id
      t.integer :project_id
    end
  end

  def self.down
    drop_table :partners_projects
  end
end