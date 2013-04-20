require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  should validate_presence_of :sender_email
  should validate_presence_of :listing_id
  should validate_presence_of :text
  
  should ensure_length_of(:sender_email).is_at_most(255)
  should allow_value("d@d.com").for(:sender_email)
  should_not allow_value('d.com').for(:sender_email)
  
  should ensure_length_of(:text).is_at_most(1000)
  
  [:sender_email, :text].each do |attr|
      should allow_mass_assignment_of(attr)
  end
  
  should_not allow_mass_assignment_of(:listing_id)
end