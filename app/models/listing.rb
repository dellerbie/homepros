class Listing < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :budget, :city, :company_logo, :company_name, :contact_email,
    :portfolio_photo, :portfolio_photo_description, :state, :website, :phone_area_code, :phone_exchange, :phone_suffix,
    :specialty
  
  validates_presence_of :company_name
  
end
