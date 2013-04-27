require 'spec_helper'

describe ListingsController do
  it 'successfully claim listing' do    
    listing = FactoryGirl.create(:listing, claimable: true, id: 100000)
    
    user = FactoryGirl.attributes_for(:user, email: 'claim@example.com')
    user[:password_confirmation] = user[:password]
    
    expect(listing).to be_claimable
    
    expect {
      post :claim, id: listing.id, user: user
    }.to change { User.count }
    
    listing.reload
    
    user = User.first(conditions: ['email = ?', user[:email]])
    
    expect(listing).to_not be_claimable
    expect(user.listing).to eql(listing)
    expect(user).to eql(listing.user)
    
    expect(response).to redirect_to(listing_path(listing))
  end
  
  it 'cant claim an unclaimable listing' do     
    user = FactoryGirl.attributes_for(:user, email: 'claim2@example.com')
    user[:password_confirmation] = user[:password]
    
    listing = FactoryGirl.create(:listing, claimable: false, id: 100001)
    
    expect(listing).to_not be_claimable
    
    expect {
      post :claim, id: listing.id, user: user
    }.to_not change { User.count }
    
    listing.reload
    expect(listing).to_not be_claimable
    expect(listing.user_id).to be_nil
    
    expect(flash[:alert]).to eql("This listing can't be claimed")
  end
end