class Listing < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :budget_max, :budget_min, :city, :company_logo, :company_name, :contact_email, :phone, 
    :portfolio_photo, :portfolio_photo_description, :state, :website
    
  attr_accessor :phone_area_code, :phone_pre, :phone_post
  
end
