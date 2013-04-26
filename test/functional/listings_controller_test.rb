require 'test_helper'

class ListingsControllerTest < ActionController::TestCase
  test 'claim' do
    listing = FactoryGirl.create(:listing, claimable: true)
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

end
