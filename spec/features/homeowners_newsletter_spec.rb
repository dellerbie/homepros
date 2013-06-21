require 'spec_helper'

feature 'Homeowners Newsletter', js: true do
  
  before(:each) do
    @city = FactoryGirl.create(:city)
  end
  
  scenario 'subscribe' do 
    listing = FactoryGirl.create(:free_listing)
    visit listing_path(listing)
    page.should have_content("Join The OCHomeMaster's Newsletter")
    
    within('#homeowners-subscribe-modal') do
      fill_in 'Your Email:', with: 'test@gmail.com'
      select @city.name, from: 'Which city do you live in?'
      choose 'Yes'
      click_on 'Subscribe'
      
      page.should have_content("You are now subscribed to the OCHomeMaster's newsletter.")
    end
  end
  
  scenario 'dismiss' do 
    listing = FactoryGirl.create(:free_listing)
    visit listing_path(listing)
    page.should have_content("Join The OCHomeMaster's Newsletter")
    within('#homeowners-subscribe-modal') do
      click_on 'No, thanks'
    end
    
    page.should_not have_content("Join The OCHomeMaster's Newsletter")
  end
  
  scenario 'signed in' do 
    listing = FactoryGirl.create(:free_listing)
    sign_in(listing.user)
    visit listing_path(listing)
    
    page.should_not have_content("Join The OCHomeMaster's Newsletter")
  end
end