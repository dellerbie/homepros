class Homeowner < ActiveRecord::Base
  belongs_to :city
  
  validates_presence_of :email
  validates_presence_of :city, message: 'Please select a city closest to you'
  
  validates_length_of :email, maximum: 255
  validates_format_of :email, :with => EmailAddress::VALID_PATTERN, :message => "Please enter a valid email address", :allow_blank => true
  
  attr_accessible :email, :city_id, :received_flier
end