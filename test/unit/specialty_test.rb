require 'test_helper'

class SpecialtyTest < ActiveSupport::TestCase
  should have_and_belong_to_many :listings
end
