require 'spec_helper'

feature 'Browse the homepage', js: true do  
  before(:each) do
    @specialty1 = FactoryGirl.create(:specialty)
    @specialty2 = FactoryGirl.create(:specialty)
    @city1 = FactoryGirl.create(:city)
    @city2 = FactoryGirl.create(:city)
    @premium_listing = FactoryGirl.create(:premium_listing, city: @city1)
    @free_listing = FactoryGirl.create(:listing, city: @city2)
    visit root_path
  end
  
  scenario 'on the homepage' do
    current_path.should eql(root_path)
    should_see_signed_out_navbar
  end
  
end