require 'spec_helper'

feature 'Business signs up', js: true do  
  before(:each) do
    @specialty = FactoryGirl.create(:specialty)
    @city = FactoryGirl.create(:city)
  end
  
  scenario 'with valid information' do
    visit root_path
    click_on 'Get Listed Today'
    
    attach_file 'user[listing_attributes][portfolio_photos_attributes][0][portfolio_photo]', File.join(Rails.root, 'spec', 'fixtures', 'files', 'gibson.jpg')
    fill_in 'Description', with: 'Lorem Ipsum dolor color set'
    fill_in "What's your company name?", with: 'Dellerbie Inc'
    select_from_chosen(@specialty.name, from: 'What do you specialize in?')
    select_from_chosen(@city.name, from: 'Which city or metro area is closest to your company headquarters?')
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