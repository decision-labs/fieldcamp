class Partner < ActiveRecord::Base
  has_and_belongs_to_many :projects
  belongs_to :user

  validates_uniqueness_of :name, :case_sensitive => false
end
