require 'spec_helper'

feature 'Business signs up', js: true do  
  before(:each) do
    @specialty = FactoryGirl.create(:specialty)
    @city = FactoryGirl.create(:city)
    visit root_path
    click_on 'Get Listed Today'
  end
  
  scenario 'with valid information' do
    company_name = 'Dellerbie Inc'
    description = 'Lorem Ipsum dolor color set'
    
    attach_file 'user[listing_attributes][portfolio_photos_attributes][0][portfolio_photo]', File.join(Rails.root, 'spec', 'fixtures', 'files', 'gibson.jpg')
    attach_file 'user[listing_attributes][company_logo_photo]', File.join(Rails.root, 'spec', 'fixtures', 'files', 'fender.jpg')
    fill_in 'Description', with: description
    fill_in "What's your company name?", with: company_name
    select_from_chosen(@specialty.name, from: 'What do you specialize in?')
    select_from_chosen(@city.name, from: 'Which city or metro area is closest to your company headquarters?')
    fill_in "Sales contact email", with: 'slowblues@gmail.com'
    fill_in "Website URL (optional)", with: 'dellerbie.com'
    fill_in "Phone Number", with: "201-253-7772"
    fill_in "Your email address", with: "dellerbie@gmail.com"
    fill_in "Password", with: 'ffffff'
    fill_in "Password again", with: 'ffffff'
    
    within('.preview .listing-container') do
      find('.company-name').should have_content(company_name)
      find('.specialties').should have_content(@specialty.name)
      find('.location').should have_content(@city.name)
      find('.portfolio-img')[:src].match(/\/previews\/.*\.jpg/).should be_true
      find('.description').should have_content(description)
    end
    
    click_on 'Create Account'
    
    should_see_signed_in_navbar_for_mvp_user
    
    current_path.should eql(new_upgrade_path)
  end
  
  scenario 'invalid information' do 
    click_on 'Create Account'
    
    page.should have_content('Please review the problems below:')
    
    %w(portfolio_photos_portfolio_photo company_name specialties city contact_email phone).each do |element|
      page.should have_css(".user_listing_#{element}.error")
    end
    
    %w(email password).each do |element|
      page.should have_css(".user_#{element}.error")
    end
    
    current_path.should eql('/users')
    page.should have_content('Login')
    
    click_on 'Cancel'
    current_path.should eql(root_path)
  end 
end