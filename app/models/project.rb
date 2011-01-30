class Project < ActiveRecord::Base
  validate :title, :presence => true
end
