class Listing < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :budget_max, :budget_min, :city, :company_logo, :company_name, :contact_email, :phone, 
    :portfolio_photo, :portfolio_photo_description, :state, :website, :phone_area_code, :phone_pre, :phone_post
    
  attr_accessor :phone_area_code, :phone_pre, :phone_post
  
  validates_presence_of :company_name
  
end
