class Project < ActiveRecord::Base
  belongs_to :location
  has_many :events

  has_and_belongs_to_many :sectors
  has_and_belongs_to_many :partners

  validates_presence_of :title
end
