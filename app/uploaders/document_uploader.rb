# encoding: utf-8
class DocumentUploader < CarrierWave::Uploader::Base
  storage :file

  def root
    File.join(Rails.root, "public/")
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(doc docx xls xlsx rtf pdf odt txt pages csv zip)
  end
end
