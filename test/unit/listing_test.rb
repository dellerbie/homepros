require 'test_helper'

class ListingTest < ActiveSupport::TestCase
  should validate_presence_of :city
  should validate_presence_of :portfolio_photo
  should validate_presence_of :portfolio_photo_description
  should validate_presence_of :company_name
  should validate_presence_of :specialty
  should validate_presence_of :budget
  should validate_presence_of :city
  should validate_presence_of :contact_email
  should validate_presence_of :phone_area_code
  should validate_presence_of :phone_exchange
  should validate_presence_of :phone_suffix
  
  should_not validate_presence_of :company_logo
  should_not validate_presence_of :website
  
  should ensure_length_of(:portfolio_photo_description).is_at_most(255)
  should ensure_length_of(:company_name).is_at_most(255)
  should ensure_length_of(:contact_email).is_at_most(255)
  should ensure_length_of(:website).is_at_most(255)
end
