require 'spec_helper'

describe Question do
  it { should validate_presence_of :sender_email }
  it { should validate_presence_of :listing_id }
  it { should validate_presence_of :text }
  
  it { should ensure_length_of(:sender_email).is_at_most(255) }
  it { should allow_value("d@d.com").for(:sender_email) }
  it { should_not allow_value('d.com').for(:sender_email) }
  
  it { should ensure_length_of(:text).is_at_most(1000) }
  
  [:sender_email, :text].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end
  
  it { should_not allow_mass_assignment_of(:listing_id) }
end