class Image < ActiveRecord::Base
  belongs_to :event

  validates :asset, :presence => true

  mount_uploader :asset, ImageUploader
end
