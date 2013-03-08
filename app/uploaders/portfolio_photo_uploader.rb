# encoding: utf-8

class PortfolioPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_fit => [195, 136]

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
