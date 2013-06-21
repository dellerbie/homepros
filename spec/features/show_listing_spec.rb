require 'spec_helper'

feature 'Listing show view', js: true do 
  
  def should_be_a_contactable_listing(listing)
    page.should have_content('Ask this business a question')
    page.should have_content('Contact Us')
    page.should have_content("Email #{listing.company_name}")
  end
  
  def should_not_be_a_contactable_listing(listing)
    page.should_not have_content('Ask this business a question')
    page.should_not have_content('Contact Us')
    page.should_not have_content("Email #{listing.company_name}")
  end
  
  def dismiss_subscribe_modal
    within('#homeowners-subscribe-modal') do
      click_on 'No, thanks'
    end
  end
  
  scenario 'claimable listing' do 
    listing = FactoryGirl.create(:claimable_listing)
    visit listing_path(listing)
    dismiss_subscribe_modal
    
    page.should have_content(listing.company_name)
    page.should have_content('Claim this listing')
    page.should have_content("Specialties: #{listing.specialties.map(&:name).join(', ')}")
    page.should have_content("Headquarted in: #{listing.city.name}, CA")
    page.should have_content('Website')
    page.should have_content(listing.website)
    
    should_be_a_contactable_listing(listing)
  end
  
  scenario 'with no contact information' do
    listing = FactoryGirl.create(:claimable_listing, contact_email: Listing::NO_CONTACT_EMAIL, 
                website: Listing::NO_WEBSITE, phone: Listing::NO_PHONE)
                
    visit listing_path(listing)
    dismiss_subscribe_modal
    
    should_not_be_a_contactable_listing(listing)
    page.should_not have_content('Website')
    page.should_not have_content(listing.website)
  end
  
  scenario 'claimed listing' do 
    listing = FactoryGirl.create(:free_listing)
    visit listing_path(listing)
    dismiss_subscribe_modal
    
    page.should_not have_content('Claim this listing')
  end
  
  scenario "signed in user's listing" do 
    listing = FactoryGirl.create(:free_listing)
    sign_in(listing.user)
    visit listing_path(listing)
    
    page.should have_content(listing.company_name)
    page.should_not have_content('Claim this listing')
    should_not_be_a_contactable_listing(listing)
  end
  
  scenario 'back to listings' do
    listing = FactoryGirl.create(:free_listing)
    visit listing_path(listing)
    dismiss_subscribe_modal
    
    click_on 'Back'
    current_path.should eql(root_path)
  end
end