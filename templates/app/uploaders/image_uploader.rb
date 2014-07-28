# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def extension_white_list
    %w(jpg jpeg png)
  end

end
