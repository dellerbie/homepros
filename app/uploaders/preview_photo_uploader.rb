# encoding: utf-8

class PreviewPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :fog

  def store_dir
    "previews"
  end

  process :resize_to_fit => [195, 136]
  
  version :logo do
    process :resize_to_fill => [150, 50]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end
  
  protected
  
  def secure_token(length=16)
    if model.token
      model.token
    else 
      begin
        token = SecureRandom.hex(length/2)
      end while model.class.exists?(:token => token)
      model.token = token
    end
  end

end
