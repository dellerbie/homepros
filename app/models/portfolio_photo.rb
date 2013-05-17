class PortfolioPhoto < ActiveRecord::Base
  attr_accessible :description, :portfolio_photo, :portfolio_photo_cache
  
  belongs_to :listing
  
  mount_uploader :portfolio_photo, PortfolioPhotoUploader
  
  validates_presence_of :portfolio_photo
  validates :portfolio_photo, :file_size => { :maximum => 10.megabytes }
  
  validates_presence_of :description
  validates_length_of :description, maximum: 255
end
