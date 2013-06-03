require 'spec_helper'

feature 'Business signs up', js: true do
  before(:each) do

  end
  
  scenario 'with valid information' do
    @city1 = FactoryGirl.create(:city)
    @city2 = FactoryGirl.create(:city)
    @specialty1 = FactoryGirl.create(:specialty)
    @specialty2 = FactoryGirl.create(:specialty)
    
    visit root_path
    click_on 'Get Listed Today'
    
    attach_file 'user[listing_attributes][portfolio_photos_attributes][0][portfolio_photo]', File.join(Rails.root, 'spec', 'fixtures', 'files', 'gibson.jpg')
    fill_in 'Description', with: 'Lorem Ipsum dolor color set'
    fill_in "What's your company name?", with: 'Dellerbie Inc'
    select_from_chosen('#user_listing_attributes_specialty_ids_chzn .search-field input', @specialty1.name)
    select_from_chosen('#user_listing_attributes_city_id_chzn .chzn-single', @city1.name)
    fill_in "Sales contact email", with: 'slowblues@gmail.com'
    fill_in "Website URL (optional)", with: 'dellerbie.com'
    fill_in "Phone Number", with: "201-253-7772"
    fill_in "Your email address", with: "dellerbie@gmail.com"
    fill_in "Password", with: 'ffffff'
    fill_in "Password again", with: 'ffffff'
    
    click_on 'Create Account'
    
    expect(page).to have_content('Logout')
  end
end