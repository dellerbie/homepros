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
  
  scenario 'forgot password' do
    visit new_user_session_path
    click_on "Forgot your password?"
    
    fill_in 'user_email', with: @user.email
    click_on 'Send me reset password instructions'
    page.should have_content('You will receive an email with instructions about how to reset your password in a few minutes.')
    current_path.should eql(new_user_session_path)
  end
  
  scenario 'forgot password, user not found' do
    visit new_user_session_path
    click_on "Forgot your password?"
    
    fill_in 'user_email', with: 'unknownuser@gmail.com'
    click_on 'Send me reset password instructions'
    
    page.should have_content('Please review the problems below:')
    page.should have_css('.user_email.error')
  end
  
end