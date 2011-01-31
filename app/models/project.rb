class Project < ActiveRecord::Base
  belongs_to :location
  validate :title, :presence => true
end
