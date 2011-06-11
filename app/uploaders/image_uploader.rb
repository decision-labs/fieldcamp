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

end
