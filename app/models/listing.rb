class Listing < ActiveRecord::Base
  attr_accessible :budget_max, :budget_min, :city, :company_logo, :company_name, :contact_email, :phone, :portfolio_photo, :portfolio_photo_description, :state, :website
end
