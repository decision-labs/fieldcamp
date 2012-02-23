class Document < ActiveRecord::Base
  belongs_to :event

  validates :asset, :presence => true

  mount_uploader :asset, DocumentUploader
end
