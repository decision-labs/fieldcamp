class Image < ActiveRecord::Base
  attr_accessible :file, :title
  validates :title, :presence => true
  mount_uploader :file, ImageUploader
end
