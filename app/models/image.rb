class Image < ActiveRecord::Base
  validates :title, :presence => true
  validates :asset, :presence => true

  mount_uploader :asset, ImageUploader
end
