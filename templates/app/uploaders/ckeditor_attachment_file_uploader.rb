# encoding: utf-8
class CkeditorAttachmentFileUploader < CarrierWave::Uploader::Base
  include Ckeditor::Backend::CarrierWave
  include Cloudinary::CarrierWave

  [:extract_content_type, :set_size, :read_dimensions].each do |method|
    define_method :"#{method}_with_cloudinary" do
      send(:"#{method}_without_cloudinary") if self.file.is_a?(CarrierWave::SanitizedFile)
      {}
    end
    alias_method_chain method, :cloudinary
  end
  
  def extension_white_list
    Ckeditor.attachment_file_types
  end
end


