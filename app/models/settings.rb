class Settings < ActiveRecord::Base
  belongs_to :user
  belongs_to :location

  validates :location_id, :presence => true, :format => { :with => /[0-9]+/ }
end
