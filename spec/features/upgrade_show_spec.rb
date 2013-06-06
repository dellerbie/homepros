require 'spec_helper'

feature 'Upgrade Show', js: true do
  
  before(:each) do
    @listing = FactoryGirl.create(:premium_listing)
    user = @listing.user
    sign_in(user)
    visit upgrade_path(@listing)
  end
  
  scenario 'upgrade show' do
    current_path.should eql(upgrade_path(@listing))
    page.should have_content('You have successfully been upgraded to a Premium listing!')
    page.should have_css('.listing-container.premium')
    should_see_premium_navbar
  end
end