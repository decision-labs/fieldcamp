class Location < ActiveRecord::Base
  has_many :projects
  belongs_to :user
  has_many :children, :class_name => "Location", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent, :class_name => "Location"
  has_many :events, :through => :projects

  set_rgeo_factory_for_column(:geom, RGeo::Geographic.simple_mercator_factory)
  # acts_as_geom :geom => :multi_polygon

  cattr_reader :per_page

  attr_reader :projects_count, :total_projects

  @@per_page = 5

  scope :world,     where(:admin_level => -1)
  scope :countries, where(:admin_level => 0)
  scope :provinces, where(:admin_level => 1)

  # def self.user_location_scoped(location_ids)
  #   scope :all, where(:id => location_ids)
  # end

  def child_projects
    # find projects with location.parent_id = self.id
    # join projects on location.parent_id = self.id
    Project.where("locations.parent_id = ? OR location_id = ?",self.id, self.id).joins(:location).includes(:events)
  end

  def total_projects(opts={})
    count = 0
    if opts[:include_children]
      count = self.child_projects.count
    else
      count = self.projects.count
    end
    count
  end

  def world?
    (self.id == Location.where(:name => "World").first.id)
  end

  def self.search(params)
    query_str = params[:q]
    user_location_id = params[:user_location_id]

    parent_result = Location.find_by_sql(
      "SELECT id, parent_id FROM locations
        WHERE lower(name) LIKE \'%#{query_str.downcase}%\' limit 1").first

    return [] if parent_result.blank?

    if user_location_id && user_location_id != parent_result.id
      return [] unless self.has_ancestor?(parent_result, user_location_id)
    end

    locations = Location.find_by_sql(
      "SELECT id, name, ST_Envelope(geom) as geom
        FROM locations
        WHERE parent_id = #{parent_result.id} OR id = #{parent_result.id}
        ORDER BY id ASC;")

    results = locations.as_json.collect{|l|
      loc         = l["location"]
      geom        = loc["geom"]
      loc["geom"] = JSON.parse(geom.as_geojson)
      loc["center"] = {:x => geom.envelope.center.x, :y => geom.envelope.center.y }
      loc
    }
  end

  private
  
  def self.has_ancestor?(loc, ancestor_id)
    return true  if loc.parent_id == ancestor_id
    return false if loc.parent.world?

    has_ancestor?(loc.parent, ancestor_id)
  end

end
