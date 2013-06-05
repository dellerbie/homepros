require 'spec_helper'

describe RegistrationsController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  let(:valid_listing) do
    listing_attributes = FactoryGirl.attributes_for(:listing).except(:state, :specialties, :city)
    listing_attributes[:specialty_ids] = [FactoryGirl.create(:specialty).id, FactoryGirl.create(:specialty).id]
    listing_attributes[:city_id] = FactoryGirl.create(:city).id
    listing_attributes[:company_logo_photo] = Rack::Test::UploadedFile.new(Rails.root.to_s + '/spec/fixtures/files/guitar.jpg', 'image/jpeg')
    listing_attributes[:portfolio_photos_attributes] = [FactoryGirl.attributes_for(:portfolio_photo, portfolio_photo: Rack::Test::UploadedFile.new(Rails.root.to_s + '/spec/fixtures/files/guitar.jpg', 'image/jpeg'))]
    listing_attributes
  end
  
  let(:valid_user) do
    user = FactoryGirl.attributes_for(:user)
    user[:listing_attributes] = valid_listing
    user
  end
  
  let(:valid_user_invalid_listing) do
    user = valid_user
    user[:listing_attributes] = {}
    user
  end
  
  let(:invalid_user_valid_listing) do
    user = FactoryGirl.attributes_for(:user).except(:password)
    user[:listing_attributes] = valid_listing
    user
  end
  
  it 'should successfully register a user and redirect to users listing' do
    user = valid_user
    
    expect {
      post :create, user: user
    }.to change{ User.count }
    
    saved_user = User.find_by_email(user[:email])
    expect(saved_user).to_not be_nil
    expect(saved_user.listing).to_not be_nil
    expect(response).to redirect_to new_upgrade_path
  end
  
  it 'should not register a user with an invalid listing' do 
    expect {
      post :create, user: valid_user_invalid_listing
    }.to_not change{ User.count }
  end
  
  it 'should not register an invalid user with a valid listing' do
    expect {
      post :create, user: invalid_user_valid_listing
    }.to_not change{ User.count }
  end
end