require 'spec_helper'

feature 'My Account', js: true do
  
  before(:each) do 
    @user = FactoryGirl.create(:free_listing).user
    sign_in(@user)
    click_on 'My Account'
  end
  
  scenario 'edit email' do
    fill_in 'user_email', with: 'mynewemail@gmail.com'
    click_on 'Update'
    
    page.should have_content('Please review the problems below:')
    page.should have_css('.user_current_password.error')
    
    fill_in 'user_current_password', with: 'abcd1234'
    click_on 'Update'
    
    page.should have_content('You updated your account successfully.')
    current_path.should eql(root_path)
    
    @user.reload.email.should eql('mynewemail@gmail.com')
  end
  
  scenario 'change password' do
    fill_in 'user_password', with: 'ffffff'
    fill_in 'user_password_confirmation', with: 'ffffff'
    fill_in 'user_current_password', with: 'abcd1234'
    click_on 'Update'
    page.should have_content('You updated your account successfully.')
    current_path.should eql(root_path)
  end
  
  scenario 'unsuccessful password change' do 
    fill_in 'user_password', with: 'ffffff'
    fill_in 'user_password_confirmation', with: '111111'
    fill_in 'user_current_password', with: 'abcd1234'
    click_on 'Update'
    
    page.should have_content('Please review the problems below:')
    page.should have_css('.user_password.error')
  end
  
  scenario 'cancel free account' do
    handle_js_confirm do 
      click_on 'Cancel my account'
    end
    page.should have_content('Bye! Your account was successfully cancelled. We hope to see you again soon.')
    current_path.should eql(root_path)
    should_see_signed_out_navbar
  end
  
end