require 'spec_helper'

describe PortfolioPhotosController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:premium_user)
    @listing = FactoryGirl.create(:listing, user: @user)
    sign_in @user
  end
  
  it 'successfully create' do
    photo = Rack::Test::UploadedFile.new(Rails.root.to_s + '/spec/fixtures/files/guitar.jpg', 'image/jpeg')
    description = 'Lorem ipsum dolor'
    
    expect {
      post :create, listing_id: @listing.id, portfolio_photo: { portfolio_photo: photo, description: description }, format: :json
    }.to change{ PortfolioPhoto.count }
    
    expect(response.status).to eql(200)
  end
  
  it 'unsuccessfully creates' do 
    expect {
      post :create, listing_id: @listing.id, portfolio_photo: { portfolio_photo: nil, description: nil }, format: :json
    }.to_not change{ PortfolioPhoto.count }
    
    expect(response.status).to eql(422)
  end
end