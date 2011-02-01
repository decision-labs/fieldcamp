class Project < ActiveRecord::Base
  belongs_to :location
  has_many :events
  validate :title, :presence => true
end
