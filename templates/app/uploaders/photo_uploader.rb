# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave
  
  def default_url
    "/fallback_#{version_name}.png"
  end

  version :slide do
    process :resize_to_fill => [1600, 600]
  end

  version :box do
    process :resize_to_fill => [360, 240]
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

end
