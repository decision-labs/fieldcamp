class Project < ActiveRecord::Base
  belongs_to :location
  belongs_to :user
  has_many :events, :dependent => :destroy

  has_and_belongs_to_many :sectors
  has_and_belongs_to_many :partners

  validates_presence_of :title

  # def self.user_location_scoped(location_ids)
  #   scope :all, where(:location_id => location_ids)
  # end

end
