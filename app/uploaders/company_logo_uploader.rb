# encoding: utf-8

class CompanyLogoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  if Rails.env.test?
    storage :file
  else 
    storage :fog
  end

  def store_dir
    "logos"
  end

  process :resize_to_fit => [150, 50]
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  def filename
    @name ||= "#{secure_token}_#{timestamp}.#{file.extension}" if original_filename.present? and super.present?
  end
  
  def timestamp
    var = :"@#{mounted_as}_timestamp"
    model.instance_variable_get(var) or model.instance_variable_set(var, Time.now.to_i)
  end
  
  protected
  
  def secure_token(length=16)
    if model.company_logo_photo_token
      model.company_logo_photo_token
    else 
      begin
        token = SecureRandom.hex(length/2)
      end while model.class.exists?(:company_logo_photo_token => token)
      model.company_logo_photo_token = token
    end
  end

end
