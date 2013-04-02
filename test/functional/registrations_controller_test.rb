require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  
  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  def valid_user
    user = FactoryGirl.attributes_for(:user)
    
    listing_attributes = FactoryGirl.attributes_for(:listing).except(:state, :specialties, :city)
    listing_attributes[:specialty_ids] = [FactoryGirl.create(:specialty).id, FactoryGirl.create(:specialty).id]
    listing_attributes[:city_id] = FactoryGirl.create(:city).id
    listing_attributes[:company_logo_photo] = fixture_file_upload('files/guitar.jpg','image/jpeg')
    listing_attributes[:portfolio_photo] = fixture_file_upload('files/guitar.jpg','image/jpeg')
    user[:listing_attributes] = listing_attributes
    
    user
  end
  
  test 'should successfully register a user' do
    user = valid_user
    post :create, user: valid_user
    
    saved_user = User.find_by_email(user[:email])
    assert_not_nil saved_user
    assert_not_nil saved_user.listing
    assert_redirected_to edit_listings_path(saved_user.listing)
  end

end
