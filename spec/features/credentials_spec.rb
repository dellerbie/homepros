require 'spec_helper'

feature 'Credentials', js: true do
  
  before(:each) do 
    @user = FactoryGirl.create(:free_listing).user
  end
  
  scenario 'login' do 
    visit new_user_session_path
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => @user.password
    click_button "Sign in"
    
    should_see_signed_in_navbar_for_mvp_user
    page.should have_content('Signed in successfully.')
    current_path.should eql(root_path)
  end
  
  scenario 'unsuccessful login' do
    visit new_user_session_path
    click_button "Sign in"
    
    page.should have_content('Invalid email or password.')
    current_path.should eql(new_user_session_path)
  end
  
  scenario 'forgot password'
  
end