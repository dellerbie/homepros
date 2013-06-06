require 'spec_helper'

feature 'Browse the homepage', js: true do  
  before(:each) do
    @specialty1 = FactoryGirl.create(:specialty)
    @specialty2 = FactoryGirl.create(:specialty)
    @city1 = FactoryGirl.create(:city)
    @city2 = FactoryGirl.create(:city)
    @premium_listing = FactoryGirl.create(:premium_listing, city: @city1)
    @premium_listing.specialties = [@specialty1]
    @premium_listing.save!
    @free_listing = FactoryGirl.create(:listing, city: @city2)
    @free_listing.specialties = [@specialty2]
    @free_listing.save!
    
    visit root_path
  end
  
  scenario 'show listings' do
    current_path.should eql(root_path)
    should_see_signed_out_navbar
    
    page.should have_content('Showing professionals in All Cities specializing in All Specialties')
    page.should have_css('ul.thumbnails li', count: 2)
  end

  # not working
  # scenario 'filters' do
  #   click_on('All Cities')
  #   click_on(@city1.name)
  #   
  #   # current_path.should eql("/#{@city1.name}")
  #   
  #   page.should have_content("Showing professionals in #{@city1.name} specializing in All Specialties")
  # 
  #   page.should have_css('ul.thumbnails li', count: 1)
  #   page.should have_css('.listing-container.thumbnail.premium')
  #   within('.listing-container.thumbnail.premium') do
  #     find('.company-name').should have_content(@premium_listing.company_name)
  #   end
  # end
  
end