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
  
  scenario 'upgrades' do
    User.any_instance.stub(:upgrade).and_return(true)
    
    find('.stripe-button-el').click
    fill_in 'paymentNumber', with: '4242424242424242'
    fill_in 'paymentExpiry', with: '0515'
    fill_in 'paymentName', with: 'derrick ellerbie'
    fill_in 'paymentCVC', with: '123'
    click_on 'Pay $99.00'
    
    p page.html
    
    current_path.should eql(upgrade_path(@listing))
    page.should have_content('You have successfully been upgraded to a Premium listing!')
    page.should have_css('.listing-container.premium')
    should_see_premium_navbar
  end
  
  scenario 'bad credit card'
  
end