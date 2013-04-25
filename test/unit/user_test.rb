require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_presence_of :email
  should allow_value("d@d.com").for(:email)
  should_not allow_value('d.com').for(:email)
  
  should validate_presence_of :password
end
