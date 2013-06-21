require 'spec_helper'

feature 'Claim listing', js: true do
  
  scenario 'claim' do 
    listing = FactoryGirl.create(:claimable_listing)
    
    visit listing_path(listing)
    
    within('#homeowners-subscribe-modal') do
      click_on 'No, thanks'
    end
    
    click_on 'Claim this listing'
    
    current_path.should eql(claim_listing_path(listing))
    
    page.should have_content("You are claiming #{listing.company_name}")
    
    within('.preview .listing-container') do
      find('.company-name').should have_content(listing.company_name)
      find('.specialties').should have_content(listing.specialties.map(&:name).join(', '))
      find('.location').should have_content(listing.city.name)
      find('.description').should have_content(listing.portfolio_photos.first.description)
    end
    
    fill_in "Your email address", with: "dellerbie@gmail.com"
    fill_in "Password", with: 'ffffff'
    fill_in "Password again", with: 'ffffff'
    click_on 'Create Account'
    
    current_path.should eql(new_upgrade_path)
    page.should have_content('You have successfully claimed this profile.')
  end
  
  scenario 'cancel claim' do
    listing = FactoryGirl.create(:claimable_listing)
    visit claim_listing_path(listing)
    
    click_on 'Cancel'
    
    current_path.should eql(listing_path(listing))
  end
end