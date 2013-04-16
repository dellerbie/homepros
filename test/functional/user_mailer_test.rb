require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'welcome_email' do 
    user = FactoryGirl.create(:user)
 
    assert ActionMailer::Base.deliveries.present?, 'no email delivered'
    
    email = ActionMailer::Base.deliveries.last
    assert email.body.include?("Welcome to OC Homepros Derrick!")
    assert_equal ["slowblues@gmail.com"], email.from 
    assert_equal "Welcome to OC Homepros", email.subject
  end
end
