require 'spec_helper'

feature 'Edit premium listing', js: true do
  include ActionView::Helpers::NumberHelper
  
  def sign_in_free_listing
    @listing = FactoryGirl.create(:free_listing)
    @listing.specialties = [@specialty1]
    @listing.city = @city1
    @listing.save!
    user = @listing.user
    sign_in(user)
  end
  
  def sign_in_premium_listing
    @listing = FactoryGirl.create(:premium_listing)
    @listing.specialties = [@specialty1]
    @listing.city = @city1
    @listing.save!
    user = @listing.user
    sign_in(user)
  end
  
  before(:each) do
    @specialty1 = FactoryGirl.create(:specialty)
    @specialty2 = FactoryGirl.create(:specialty)
    @city1 = FactoryGirl.create(:city)
    @city2 = FactoryGirl.create(:city)
    @listing = nil
  end
  
  scenario 'premium successful' do
    sign_in_premium_listing
    
    find('.navbar .actions .premium-user').should have_content('Premium')
    click_on 'My Listing'
    click_on 'Edit'
    current_path.should eql(edit_listing_path(@listing))
    page.should have_css('.premium.preview')
    page.should have_css('form.premium')
    
    should_update_listing(@listing, @specialty2, @city2)
  end
  
  scenario 'free successful' do 
    sign_in_free_listing
    
    find('.navbar .actions').should have_content('Upgrade to Premium')
    click_on 'My Listing'
    click_on 'Edit'
    current_path.should eql(edit_listing_path(@listing))
    
    page.should_not have_css('.premium.preview')
    page.should_not have_css('form.premium')
    page.should have_css('.preview')
    
    should_update_listing(@listing, @specialty2, @city2)
  end
  
  scenario 'premium failure' do
    sign_in_premium_listing
    should_fail_to_update
  end
  
  scenario 'free failure' do
    sign_in_free_listing
    should_fail_to_update
  end
  
  def should_cancel
    click_on 'My Listing'
    click_on 'Edit'
    click_on 'Cancel'
    current_path.should eql(listing_path(@listing))
  end
  
  scenario 'premium cancel' do 
    sign_in_premium_listing
    should_cancel
  end
  
  scenario 'free cancel' do 
    sign_in_free_listing
    should_cancel
  end
end