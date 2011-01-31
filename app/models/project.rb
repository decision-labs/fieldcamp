class Project < ActiveRecord::Base
  has_one :location
  validate :title, :presence => true
end
