require 'test_helper'

class ListingsControllerTest < ActionController::TestCase
  
  def setup
    DatabaseCleaner.start
  end
  
  def teardown
    DatabaseCleaner.clean
  end
  
  test 'successfully claim listing' do    
    listing = FactoryGirl.create(:listing, claimable: true, id: 100000)
    
    user = FactoryGirl.attributes_for(:user, email: 'claim@example.com')
    user[:password_confirmation] = user[:password]
    
    assert listing.claimable?
    
    assert_difference('User.count') do 
      post :claim, id: listing.id, user: user
    end
    
    listing.reload
    
    user = User.first(conditions: ['email = ?', user[:email]])
    
    assert !listing.claimable?
    assert_equal user.listing, listing
    assert_equal user, listing.user
    
    assert_redirected_to listing_path(listing)
  end
  
  test 'cant claim an unclaimable listing' do     
    user = FactoryGirl.attributes_for(:user, email: 'claim2@example.com')
    user[:password_confirmation] = user[:password]
    
    listing = FactoryGirl.create(:listing, claimable: false, id: 100001)
    
    assert !listing.claimable?
    
    assert_no_difference('User.count') do 
      post :claim, id: listing.id, user: user
    end
    
    listing.reload
    assert !listing.claimable?
    assert_nil listing.user_id
    
    assert_equal "This listing can't be claimed", flash[:alert]
  end

end
