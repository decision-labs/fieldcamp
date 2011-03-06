class Location < ActiveRecord::Base
  has_many :projects
  belongs_to :user
  has_many :children, :class_name => "Location", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Location"

  acts_as_geom :geom => :multi_polygon
end
