class Location < ActiveRecord::Base
  has_many :projects
  belongs_to :user
  has_many :children, :class_name => "Location", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Location"

  acts_as_geom :geom => :multi_polygon

  cattr_reader :per_page
  @@per_page = 5

  # def self.user_location_scoped(location_ids)
  #   scope :all, where(:id => location_ids)
  # end
  def child_projects
    # find projects with location.parent_id = self.id
    # join projects on location.parent_id = self.id
    Project.where("locations.parent_id = ? OR location_id = ?", self.id, self.id).joins(:location).all
  end
end
