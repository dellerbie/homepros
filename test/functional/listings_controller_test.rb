require 'test_helper'

class ListingsControllerTest < ActionController::TestCase
  
  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  test 'claim' do
    listing = FactoryGirl.build(:listing, claimable: true)
    listing.specialties.destroy_all
    listing.specialties << FactoryGirl.create(:specialty) << FactoryGirl.create(:specialty)
    listing.save!
    
    user = FactoryGirl.attributes_for(:user, email: 'claim@example.com')
    user[:password_confirmation] = user[:password]
    
    assert listing.claimable?
    
    assert_difference('User.count') do 
      post :claim, id: listing.id, user: user, format: :json
    end
    
    listing.reload
    
    user = User.first(conditions: ['email = ?', user[:email]])
    
    assert !listing.claimable?
    assert_equal user.listing, listing
    assert_equal user, listing.user
    
    assert_response :success
  end
  
  test 'cant claim an unclaimable listing' do 
    user = FactoryGirl.attributes_for(:user, email: 'claim2@example.com')
    user[:password_confirmation] = user[:password]
    
    listing = FactoryGirl.build(:listing, claimable: false)
    listing.specialties.destroy_all
    listing.specialties << FactoryGirl.create(:specialty) << FactoryGirl.create(:specialty)
    listing.save!
    
    assert !listing.claimable?
    
    assert_no_difference('User.count') do 
      post :claim, id: listing.id, user: user, format: :json
    end
    
    listing.reload
    assert !listing.claimable?
    assert_nil listing.user_id
    
  end

end
