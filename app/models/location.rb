class Location < ActiveRecord::Base
  has_many :projects
end
