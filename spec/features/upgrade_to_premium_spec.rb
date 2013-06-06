require 'spec_helper'

feature 'Upgrade to Premium', js: true do
  
  before(:each) do
    @listing = FactoryGirl.create(:free_listing)
    user = @listing.user
    sign_in(user)
    click_on 'Upgrade to Premium'
    current_path.should eql(new_upgrade_path)
  end
  
  scenario 'has marketing copy' do
    page.should have_content('Upgrade to a Premium Listing')
    page.should have_content('This is your free listing')
    page.should have_content('Your premium listing will look like this')
    page.should have_css('.stripe-button-el')
    within('.stripe-button-el') do 
      find('span').should have_content('Upgrade to Premium')
    end
    
    page.should have_css('a.not-now')
    page.should have_css('.preview.free')
    page.should have_css('.preview.premium')
    
    within('.listing-container.premium') do 
      find('.bx-wrapper').should have_css('.bx-controls-direction')
      find('.bx-controls').should have_css('.bx-pager-item', count: 6)
    end
  end
  
  scenario 'stripe modal' do 
    page.should have_css('iframe.stripe-app', visible: false)
    find('.stripe-button-el').click
    page.should have_css('iframe.stripe-app', visible: true)
    page.should have_css('#paymentNumber')
    page.should have_css('#paymentExpiry')
    page.should have_css('#paymentName')
    page.should have_css('#paymentCVC')
    page.should have_css('#paymentNumber')
    page.should have_css('button', text: 'Pay $99.00')
  end
  
  scenario 'not now' do
    click_on 'Not Now'
    current_path.should eql(listing_path(@listing))
  end
end