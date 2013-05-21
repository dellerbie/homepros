require 'spec_helper'

describe PortfolioPhotosController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:premium_user)
    @listing = FactoryGirl.create(:listing, user: @user)
    sign_in @user
  end
  
  let(:photo) { Rack::Test::UploadedFile.new(Rails.root.to_s + '/spec/fixtures/files/guitar.jpg', 'image/jpeg') }
  let(:description) { 'Lorem ipsum dolor' }
  
  it 'successfully create' do
    expect {
      post :create, listing_id: @listing.id, portfolio_photo: { portfolio_photo: photo, description: description }, format: :json
    }.to change{ PortfolioPhoto.count }
    
    expect(response.status).to eql(200)
  end
  
  describe 'unsuccessful' do
    it 'blank photo' do 
      expect {
        post :create, listing_id: @listing.id, portfolio_photo: { portfolio_photo: nil, description: nil }, format: :json
      }.to_not change{ PortfolioPhoto.count }

      photo = assigns(:portfolio_photo)

      expect(response.status).to eql(422)
      expect(photo.errors[:portfolio_photo]).to eql(["can't be blank"])
    end
    
    it 'description too long' do
      expect {
        post :create, listing_id: @listing.id, portfolio_photo: { portfolio_photo: photo, description: 'a' * 256 }, format: :json
      }.to_not change{ PortfolioPhoto.count }

      photo = assigns(:portfolio_photo)

      expect(response.status).to eql(422)
      expect(photo.errors[:description]).to eql(["is too long (maximum is 255 characters)"])
    end
    
    it 'photos over the limit' do 
      @listing.portfolio_photos << FactoryGirl.build_list(:portfolio_photo, Listing::MAX_PREMIUM_PHOTOS - 1)
      expect(@listing.portfolio_photos.count).to eql(Listing::MAX_PREMIUM_PHOTOS)
      
      expect {
        post :create, listing_id: @listing.id, portfolio_photo: { portfolio_photo: photo, description: description }, format: :json
      }.to_not change{ PortfolioPhoto.count }

      expect(response.status).to eql(422)
      photo = assigns(:portfolio_photo)
      expect(photo.errors[:base]).to eql(["You cannot have more than 6 photos"])
    end
  end
end