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
    Project.where("locations.parent_id = ? OR location_id = ?", self.id, self.id).joins(:location).includes(:events)
  end

  def self.search(location)
    parent = Location.find_by_sql("SELECT id FROM locations WHERE lower(name) LIKE \'%#{location}%\' limit 1").first
    Location.find_by_sql("SELECT id, name
      FROM locations
      WHERE parent_id = #{parent.id} OR id = #{parent.id};")
  end

end
