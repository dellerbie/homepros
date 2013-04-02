ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  class ActionController::TestCase
    include Devise::TestHelpers
  end
  
  class ActionView::TestCase
    include ::Sprockets::Helpers::RailsHelper # so image_tag returns /assets/... instead of /images/...
                                              # it's included in ActionView::Base on app load but not the test case for some reason
                                              # see actionpack/lib/sprockets/helpers/rails_helper.rb
  end
end