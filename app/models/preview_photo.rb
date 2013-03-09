class PreviewPhoto < ActiveRecord::Base
  attr_accessible :photo
  
  mount_uploader :photo, PreviewPhotoUploader
  
  validates :photo, :file_size => { :maximum => 10.megabytes }
end
