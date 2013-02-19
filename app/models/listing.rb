class Listing < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :budget, :city, :company_logo, :company_name, :contact_email,
    :portfolio_photo, :portfolio_photo_description, :state, :website, :phone_area_code, :phone_exchange, :phone_suffix,
    :specialty
  
  validates_presence_of :portfolio_photo, :portfolio_photo_description, :company_name, :specialty, :budget, :city, :contact_email, 
    :phone_area_code, :phone_exchange, :phone_suffix
    
  validates_length_of :portfolio_photo_description, maximum: 255
  validates_length_of :company_name, maximum: 255
  validates_length_of :contact_email, maximum: 255
  validates_length_of :website, maximum: 255
  
end
