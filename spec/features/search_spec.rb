require 'spec_helper'

feature 'Search for a listing by company name', js: true do
  
  before(:each) do 
    @joes_listing = FactoryGirl.create(:free_listing, company_name: "Joe's Home Improvement")
    @sams_listing = FactoryGirl.create(:premium_listing, company_name: "Sam's Landscaping Pros")
    
    visit root_path
    page.should have_css('.search.navbar-form input')
  end
  
  scenario 'has search results' do
    fill_in 'q', with: 'joe'
    find('.search.navbar-form button').click
    
    page.should have_content(@joes_listing.company_name)
  end
  
  scenario 'no search results' do
    
  end
end