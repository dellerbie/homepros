require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  
  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  def valid_listing
    listing_attributes = FactoryGirl.attributes_for(:listing).except(:state, :specialties, :city)
    listing_attributes[:specialty_ids] = [FactoryGirl.create(:specialty).id, FactoryGirl.create(:specialty).id]
    listing_attributes[:city_id] = FactoryGirl.create(:city).id
    listing_attributes[:company_logo_photo] = fixture_file_upload('files/guitar.jpg','image/jpeg')
    listing_attributes[:portfolio_photo] = fixture_file_upload('files/guitar.jpg','image/jpeg')

    listing_attributes
  end
  
  def valid_user
    user = FactoryGirl.attributes_for(:user)
    user[:listing_attributes] = valid_listing
    user
  end
  
  def valid_user_invalid_listing
    user = valid_user
    user[:listing_attributes] = {}
    user
  end
  
  def invalid_user_valid_listing
    user = FactoryGirl.attributes_for(:user).except(:first_name, :last_name)
    user[:listing_attributes] = valid_listing
    user
  end
  
  test 'should successfully register a user and redirect to users listing' do
    user = valid_user
    
    assert_difference('User.count') do 
      post :create, user: user
    end
    
    saved_user = User.find_by_email(user[:email])
    assert_not_nil saved_user
    assert_not_nil saved_user.listing
    assert_redirected_to listing_path(saved_user.listing)
  end
  
  test 'should not register a user with an invalid listing' do 
    assert_no_difference('User.count') do 
      post :create, user: valid_user_invalid_listing
    end
  end
  
  test 'should not register an invalid user with a valid listing' do
    assert_no_difference('User.count') do 
      post :create, user: invalid_user_valid_listing
    end
  end
  
  test 'should get a welcome email upon registration' do
    post :create, user: valid_user
    
    assert ActionMailer::Base.deliveries.present?, 'no email delivered'
    email = ActionMailer::Base.deliveries.last
    assert email.body.include?("Welcome to Homepros derrick!")
    assert_equal ["no-reply@homepros.com"], email.from
  end
end
