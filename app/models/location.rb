class Location < ActiveRecord::Base
  has_many :projects
  belongs_to :user
  has_many :children, :class_name => "Location", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Location"
  has_many :events, :through => :projects

  acts_as_geom :geom => :multi_polygon

  cattr_reader :per_page
  @@per_page = 5

  # def self.user_location_scoped(location_ids)
  #   scope :all, where(:id => location_ids)
  # end
  def child_projects
    # find projects with location.parent_id = self.id
    # join projects on location.parent_id = self.id
    Project.where("locations.parent_id = ? OR location_id = ?",self.id, self.id).joins(:location).includes(:events)
  end

  def world?
    (self.id == Location.where(:name => "World").first.id)
  end

  def self.search(params)
    location = params[:q]
    user_location_id = params[:user_location_id]
    # TODO refactor to use activerecord where
    if user_location_id
      parent = Location.find_by_sql(
        "SELECT id FROM locations
          WHERE lower(name) LIKE \'%#{location.downcase}%\'
            AND id=#{user_location_id} limit 1").first
      else
      parent = Location.find_by_sql(
        "SELECT id FROM locations
          WHERE lower(name) LIKE \'%#{location.downcase}%\' limit 1").first
      end

    return [] if parent.blank?

    locations = Location.find_by_sql(
      "SELECT id, name, ST_Envelope(geom) as geom
        FROM locations
        WHERE parent_id = #{parent.id} OR id = #{parent.id}
        ORDER BY id ASC;")

    results = locations.as_json.collect{|l|
      loc         = l["location"]
      geom        = loc["geom"]
      loc["geom"] = JSON.parse(geom.as_geojson)
      loc["center"] = {:x => geom.envelope.center.x, :y => geom.envelope.center.y }
      loc
    }
  end


end
