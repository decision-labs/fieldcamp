# encoding: utf-8
class ImageUploader < CarrierWave::Uploader::Base
  storage :file
  include CarrierWave::RMagick

  def root
    File.join(Rails.root, "public/")
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_limit => [640, 640] # All images are resized to max width/height of 640px

  version :thumb do
    process :resize_to_limit => [160, 160]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
